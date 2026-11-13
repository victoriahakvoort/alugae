<?php

namespace App\Http\Services;

use App\Http\Repositories\ProductRepository;
use App\Http\Repositories\RentalRepository;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class RentalService extends BaseService
{
    public function __construct(
        private RentalRepository $rentalRepository,
        private ProductRepository $productRepository,
    ) {
        parent::__construct($rentalRepository);
    }

    public function index(?Builder $builder = null)
    {
        $builder = $builder ?? $this->repository->query();

        return parent::index($builder->with('products'));
    }

    public function show(string $id)
    {
        return parent::show($id)->load('products');
    }

    public function store(array $data)
    {
        $items = $this->prepareItems($data['products'], $data['start_date'], $data['end_date']);
        $data['total'] = $this->calculateTotal($items, $data['start_date'], $data['end_date']);
        unset($data['products']);

        return DB::transaction(function () use ($data, $items) {
            $rental = parent::store($data);
            $rental->products()->attach($items);

            return $rental->load('products');
        });
    }

    public function update(array $data, string $id)
    {
        $rental = $this->show($id);

        if (! isset($data['products']) && ! isset($data['start_date']) && ! isset($data['end_date'])) {
            return parent::update($data, $id);
        }

        $startDate = $data['start_date'] ?? $rental->start_date->format('Y-m-d');
        $endDate = $data['end_date'] ?? $rental->end_date->format('Y-m-d');
        $products = $data['products'] ?? $rental->products
            ->map(fn ($product) => ['id' => $product->id, 'quantity' => $product->pivot->quantity])
            ->all();

        $items = $this->prepareItems($products, $startDate, $endDate, $rental->id);
        $data['total'] = $this->calculateTotal($items, $startDate, $endDate);
        unset($data['products']);

        return DB::transaction(function () use ($data, $id, $items) {
            $rental = parent::update($data, $id);
            $rental->products()->sync($items);

            return $rental->load('products');
        });
    }

    private function prepareItems(array $products, string $startDate, string $endDate, ?int $ignoreRentalId = null): array
    {
        $items = [];

        foreach ($products as $item) {
            $product = $this->productRepository->show($item['id']);

            if (! $product->enabled) {
                throw ValidationException::withMessages([
                    'products' => "O produto \"{$product->name}\" está inativo.",
                ]);
            }

            $reserved = $this->rentalRepository->reservedQuantity($product->id, $startDate, $endDate, $ignoreRentalId);
            $available = $product->stock - $reserved;

            if ($item['quantity'] > $available) {
                throw ValidationException::withMessages([
                    'products' => "O produto \"{$product->name}\" não está disponível no período: restam {$available} de {$product->stock} unidades.",
                ]);
            }

            $items[$product->id] = [
                'quantity' => $item['quantity'],
                'daily_price' => $product->daily_price,
            ];
        }

        return $items;
    }

    private function calculateTotal(array $items, string $startDate, string $endDate): float
    {
        $days = (int) Carbon::parse($startDate)->diffInDays(Carbon::parse($endDate)) + 1;

        $total = 0;

        foreach ($items as $item) {
            $total += $item['quantity'] * $item['daily_price'] * $days;
        }

        return $total;
    }
}