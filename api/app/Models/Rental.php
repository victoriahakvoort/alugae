<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Rental extends Model
{
    use HasFactory;

    public const STATUSES = ['pendente', 'confirmada', 'devolvida', 'cancelada'];

    protected $fillable = [
        'customer_name',
        'customer_phone',
        'event_address',
        'start_date',
        'end_date',
        'status',
        'total',
        'notes',
    ];

    protected function casts(): array
    {
        return [
            'start_date' => 'date:Y-m-d',
            'end_date' => 'date:Y-m-d',
            'total' => 'decimal:2',
        ];
    }

     public function products(): BelongsToMany
    {
        return $this->belongsToMany(Product::class)
            ->withPivot('quantity', 'daily_price')
            ->withTimestamps();
    }
}
