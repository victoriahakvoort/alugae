<?php

namespace App\Http\Services;

use App\Http\Repositories\BaseRepository;
use Illuminate\Database\Eloquent\Builder;

class BaseService
{
    public function __construct(protected BaseRepository $repository)
    {}

    public function index(?Builder $builder = null)
    {
        $builder = $builder ?? $this->repository->query();

        return $this->repository->index($builder);
    }

    public function store(array $data)
    {
        return $this->repository->store($data);
    }

    public function show(string $id)
    {
        return $this->repository->show($id);
    }

    public function update(array $data, string $id)
    {
        return $this->repository->update($data, $id);
    }

    public function destroy(string $id)
    {
        $this->repository->destroy($id);
    }
}