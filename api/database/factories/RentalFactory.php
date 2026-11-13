<?php

namespace Database\Factories;

use App\Models\Rental;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Carbon;

/**
 * @extends Factory<Rental>
 */
class RentalFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'customer_name' => fake()->name(),
            'customer_phone' => fake()->numerify('(##) 9####-####'),
            'event_address' => fake()->streetAddress(),
            'start_date' => fake()->dateTimeBetween('+1 day', '+60 days')->format('Y-m-d'),
            'end_date' => fn (array $attributes) => Carbon::parse($attributes['start_date'])
                ->addDays(fake()->numberBetween(0, 3))
                ->format('Y-m-d'),
            'status' => fake()->randomElement(['pendente', 'confirmada']),
            'total' => 0,
            'notes' => null,
        ];
    }
}
