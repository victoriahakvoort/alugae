<?php

namespace Database\Factories;

use App\Models\Product;
use App\Models\Category;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Product>
 */
class ProductFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->randomElement(['Painel', 'Mesa', 'Bandeja', 'Suporte', 'Vaso', 'Arco'])
            . ' ' . fake()->randomElement(['redondo', 'retangular', 'dourado', 'branco', 'rústico', 'floral']),
            'description' => fake()->sentence(),
            'category_id' => Category::query()->inRandomOrder()->value('id') ?? Category::factory(),
            'stock' => fake()->numberBetween(1, 10),
            'daily_price' => fake()->randomFloat(2, 20, 1000),
            'image' => null,
            'enabled' => true,
        ];
    }
}
