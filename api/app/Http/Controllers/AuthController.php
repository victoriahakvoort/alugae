<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests\LoginRequest;
use App\Http\Services\AuthService;

class AuthController extends Controller
{
     public function __construct(private AuthService $service)
    {}

    /**
     * Faz login e devolve o token de acesso.
     *
     * @unauthenticated
     */
    public function login(LoginRequest $request)
    {
        return $this->service->login(
            $request->validated('email'),
            $request->validated('password'),
        );
    }

    /**
     * Encerra a sessão, invalidando o token atual.
     */
    public function logout(Request $request)
    {
        $this->service->logout($request->user());

        return response()->noContent();
    }

    /**
     * Devolve o usuário logado.
     */
    public function me(Request $request)
    {
        return $request->user();
    }
}
