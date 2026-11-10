<?php

namespace App\Http\Services;

use App\Http\Repositories\ProductRepository;

class ProductService extends BaseService
{
    public function __construct(ProductRepository $repository)
    {
        parent::__construct($repository);
    }
}
