<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    public const CATEGORIES = [
        'Painéis',
        'Mesas',
        'Bandejas',
        'Suportes',
        'Decoração',
        'Outros',
    ];

    protected $fillable = [
        'name',
        'description',
        'category',
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
}
