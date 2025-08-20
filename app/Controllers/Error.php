<?php

namespace App\Controllers;

use App\Controllers\BaseController;

class Error extends BaseController
{
    public function error()
    {
        return view('errors/cli/error_404');
    }
}