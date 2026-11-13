<?php

namespace Database\Seeders;

use App\Http\Services\RentalService;
use App\Models\Product;
use App\Models\Rental;
use Illuminate\Database\Seeder;
use Illuminate\Validation\ValidationException;

class RentalSeeder extends Seeder
{
    public function run(RentalService $service): void
    {
        for ($i = 0; $i < 10; $i++) {
            $data = Rental::factory()->make()->toArray();

            $data['products'] = Product::query()
                ->where('enabled', true)
                ->inRandomOrder()
                ->limit(fake()->numberBetween(1, 3))
                ->get()
                ->map(fn (Product $product) => [
                    'id' => $product->id,
                    'quantity' => fake()->numberBetween(1, max(1, intdiv($product->stock, 2))),
                ])
                ->all();

            try {
                $service->store($data);
            } catch (ValidationException) {
                // Sem estoque para essa combinação no período sorteado: segue para a próxima.
            }
        }
    }
}