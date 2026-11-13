<?php

namespace App\Http\Repositories;

use App\Models\Rental;
use Illuminate\Support\Facades\DB;

class RentalRepository extends BaseRepository
{
    public function __construct(Rental $model)
    {
        parent::__construct($model);
    }

    public function reservedQuantity(int $productId, string $startDate, string $endDate, ?int $ignoreRentalId = null): int
    {
        return (int) DB::table('product_rental')
            ->join('rentals', 'rentals.id', '=', 'product_rental.rental_id')
            ->where('product_rental.product_id', $productId)
            ->whereIn('rentals.status', ['pendente', 'confirmada'])
            ->where('rentals.start_date', '<=', $endDate)
            ->where('rentals.end_date', '>=', $startDate)
            ->when($ignoreRentalId, fn ($query) => $query->where('rentals.id', '!=', $ignoreRentalId))
            ->sum('product_rental.quantity');
    }
}