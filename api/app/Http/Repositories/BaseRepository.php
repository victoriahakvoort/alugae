<?php

namespace App\Http\Repositories;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;

class BaseRepository
{
    public function __construct(protected Model $model)
    {}

    public function query(): Builder
    {
        return $this->model->newQuery();
    }

    public function index(Builder $builder)
    {
        return $builder->get();
    }

    public function store(array $data)
    {
        return $this->model->create($data);
    }

    public function show(string $id)
    {
        return $this->model->findOrFail($id);
    }

    public function update(array $data, string $id)
    {
        $entity = $this->show($id);

        $entity->update($data);

        return $entity->fresh();
    }

    public function destroy(string $id)
    {
        $entity = $this->show($id);

        $entity->delete();
    }
}