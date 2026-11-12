<?php

namespace App\Http\Services;

use App\Http\Repositories\ProductRepository;
use Illuminate\Database\Eloquent\Builder;

class ProductService extends BaseService
{
    public function __construct(ProductRepository $repository)
    {
        parent::__construct($repository);
    }

    public function index(?Builder $builder = null)
    {
        $builder = $builder ?? $this->repository->query();

        return parent::index($builder->with('category'));
    }

    public function show(string $id)
    {
        return parent::show($id)->load('category');
    }
}
