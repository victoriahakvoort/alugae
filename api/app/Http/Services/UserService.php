<?php

namespace App\Http\Services;

use App\Http\Repositories\UserRepository;
use Illuminate\Validation\ValidationException;

class UserService extends BaseService
{
    public function __construct(UserRepository $repository)
    {
        parent::__construct($repository);
    }

    public function update(array $data, string $id)
    {   
        //Se senha vazia, remove campo de dados
        if (empty($data['password'])) {
            unset($data['password']);
        }

        return parent::update($data, $id);
    }

    public function destroy(string $id, ?int $authUserId = null)
    {
        if ((int) $id === $authUserId) {
            throw ValidationException::withMessages([
                'user' => 'Você não pode excluir a sua própria conta.',
            ]);
        }

        parent::destroy($id);
    }
}