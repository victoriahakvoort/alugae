<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Product extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'category_id',
        'stock',
        'daily_price',
        'image',
        'enabled',
    ];

    protected function casts(): array
    {
        return[
            'stock' => 'integer',
            'daily_price' => 'decimal:2',
            'enabled' => 'boolean',
        ];
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function rentals(): BelongsToMany
    {
        return $this->belongsToMany(Rental::class)
            ->withPivot('quantity', 'daily_price')
            ->withTimestamps();
    }
}
