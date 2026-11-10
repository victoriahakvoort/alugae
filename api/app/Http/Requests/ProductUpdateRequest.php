<?php

namespace App\Http\Requests;

use App\Models\Product;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ProductUpdateRequest extends FormRequest
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
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'category' => ['sometimes', 'required', Rule::in(Product::CATEGORIES)],
            'stock' => 'sometimes|required|integer|min:0',
            'daily_price' => 'sometimes|required|numeric|min:0',
            'image' => 'nullable|url',
            'enabled' => 'boolean',
        ];
    }
}
