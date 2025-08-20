<?php

namespace App\Controllers;

use App\Models\UsersModel;

class Auth extends BaseController
{
    protected $usersModel;
    public function __construct()
    {
        $this->usersModel = new UsersModel();
    }
    public function index()
    {
        return view('login');
    }

    public function login()
    {
        $user = $this->usersModel;
        $username = $this->request->getVar('username');
        $password = $this->request->getVar('password');

        $validasi = $user->where('nama_lengkap', $username)->first();

        if ($validasi) {
            $pw = $validasi['password'];

            if (password_verify($password, $pw)) {
                $set_sesi = [
                    'id' => $validasi['id'],
                    'nik' => $validasi['nik'],
                    'nama_lengkap' => $validasi['nama_lengkap'],
                    'email' => $validasi['email'],
                    'password' => $validasi['password'],
                    'demographics' => $validasi['demographics'],
                    'role' => $validasi['role'],
                ];
                session()->set($set_sesi);
                return redirect()->to('/dashboard-admin');
            } else {
                session()->setFlashdata('psn', 'password salah!!');
                return redirect()->to('/');
            }
        } else {
            session()->setFlashdata('psn', 'NIK tidak ada');
            return redirect()->to('/');
        }
    }
}