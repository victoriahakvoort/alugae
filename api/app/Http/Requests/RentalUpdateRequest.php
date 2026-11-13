<?php

namespace App\Http\Requests;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use App\Models\Rental;
use Illuminate\Validation\Rule;

class RentalUpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'customer_name' => 'sometimes|required|string|max:255',
            'customer_phone' => 'sometimes|required|string|max:20',
            'event_address' => 'nullable|string|max:255',
            'start_date' => 'sometimes|required|date|required_with:end_date',
            'end_date' => 'sometimes|required|date|required_with:start_date|after_or_equal:start_date',
            'status' => ['sometimes', 'required', Rule::in(Rental::STATUSES)],
            'notes' => 'nullable|string',
            'products' => 'sometimes|required|array|min:1',
            'products.*.id' => 'required|integer|distinct|exists:products,id',
            'products.*.quantity' => 'required|integer|min:1',
        ];
    }
}
