<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\CategoryStoreRequest;
use App\Http\Requests\CategoryUpdateRequest;
use App\Http\Services\CategoryService;

class CategoryController extends Controller
{
    public function __construct(private CategoryService $service)
    {}
    /**
     * Listar categorias
     */
    public function index()
    {
        return $this->service->index();
    }

    /**
     * Cadastrar nova categoria
     */
    public function store(CategoryStoreRequest $request)
    {
        $category = $this->service->store($request->validated());

        return response()->json($category, 201);
    }

    /**
     * Buscar categoria
     */
    public function show(string $id)
    {
        return $this->service->show($id);
    }

    /**
     * Editar categoria
     */
    public function update(CategoryUpdateRequest $request, string $id)
    {
        return $this->service->update($request->validated(), $id);
    }

    /**
     * Deletar categoria
     */
    public function destroy(string $id)
    {
        $this->service->destroy($id);

        return response()->noContent();
    }
}
