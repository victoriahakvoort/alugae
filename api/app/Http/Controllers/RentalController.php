<?php

namespace App\Http\Controllers;

use App\Http\Requests\RentalStoreRequest;
use App\Http\Requests\RentalUpdateRequest;
use App\Http\Services\RentalService;

class RentalController extends Controller
{
    public function __construct(private RentalService $service)
    {}

    /**
     * Listar
     */
    public function index()
    {
        return $this->service->index();
    }

    /**
     * Cadastrar
     */
    public function store(RentalStoreRequest $request)
    {
        $rental = $this->service->store($request->validated());

        return response()->json($rental, 201);
    }

    /**
     * Buscar
     */
    public function show(string $id)
    {
        return $this->service->show($id);
    }

    /**
     * Editar
     */
    public function update(RentalUpdateRequest $request, string $id)
    {
        return $this->service->update($request->validated(), $id);
    }

    /**
     * Excluir
     */
    public function destroy(string $id)
    {
        $this->service->destroy($id);

        return response()->noContent();
    }
}