<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\HTTP\RequestInterface;

class FilterCekRole implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $sesi = session();
        $role = $sesi->get('role');

        if (!session()->get('logged_in')) {
            return redirect()->to('/');
        }

        if (empty($arguments)) {
            return redirect()->to('/error');
        }

        if (!in_array($role, $arguments)) {
            return redirect()->to('/error');
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {

    }
}