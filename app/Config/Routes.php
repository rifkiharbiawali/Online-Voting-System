<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */

//halaman login
$routes->get('/', 'Auth::index');
$routes->get('/login', 'Auth::index');

//proses login
$routes->post('/auth/login', 'Auth::login');

//proses logout
$routes->get('/logout', 'Auth::logout');

//halaman admin
$routes->get('/dashboard-admin', 'Admin::index', ['filter' => 'auth']);
