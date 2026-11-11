<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\ProductStoreRequest;
use App\Http\Requests\ProductUpdateRequest;
use App\Http\Services\ProductService;

class ProductController extends Controller
{
    public function __construct(private ProductService $service)
    {}
    /**
     * Listar.
     */
    public function index()
    {
        return $this->service->index();
    }

    /**
     * Cadastrar.
     */
    public function store(ProductStoreRequest $request)
    {
        $product = $this->service->store($request->validated());

        return response()->json($product, 201);
    }

    /**
     * Buscar.
     */
    public function show(string $id)
    {
        return $this->service->show($id);
    }

    /**
     * Editar.
     */
    public function update(ProductUpdateRequest $request, string $id)
    {
        return $this->service->update($request->validated(), $id);
    }

    /**
     * Excluir.
     */
    public function destroy(string $id)
    {
        $this->service->destroy($id);

        return response()->noContent();
    }
}
