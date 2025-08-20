<?php

namespace App\Models;

use CodeIgniter\Model;

class UsersModel extends Model
{
    protected $table = 'users';
    protected $primaryKey = 'id';
    protected $allowedFields = [
        'nik',
        'nama_lengkap',
        'email',
        'password',
        'demographics',
        'role'
    ];
    protected $createdFields = 'created_at';
}