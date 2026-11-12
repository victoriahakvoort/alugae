<?php

namespace App\Http\Services;

use App\Http\Repositories\CategoryRepository;
use Illuminate\Validation\ValidationException;

class CategoryService extends BaseService
{
    public function __construct(CategoryRepository $repository)
    {
        parent::__construct($repository);
    }

    public function destroy(string $id)
    {
        $category = $this->show($id);

        if ($category->products()->exists()) {
            throw ValidationException::withMessages([
                'category' => 'Não é possível excluir uma categoria que possui produtos.',
            ]);
        }

        parent::destroy($id);
    }
}