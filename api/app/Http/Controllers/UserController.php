<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserStoreRequest;
use App\Http\Requests\UserUpdateRequest;
use App\Http\Services\UserService;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function __construct(private UserService $service)
    {}

    /**
     * Listar Usuário
     */
    public function index()
    {
        return $this->service->index();
    }

    /**
     * Cadastrar Usuário
     */
    public function store(UserStoreRequest $request)
    {
        $user = $this->service->store($request->validated());

        return response()->json($user, 201);
    }

    /**
     * Buscar Usuário
     */
    public function show(string $id)
    {
        return $this->service->show($id);
    }

    /**
     * Editar Usuário
     */
    public function update(UserUpdateRequest $request, string $id)
    {
        return $this->service->update($request->validated(), $id);
    }

    /**
     * Excluir Usuário
     */
    public function destroy(Request $request, string $id)
    {
        $this->service->destroy($id, $request->user()->id);

        return response()->noContent();
    }
}
