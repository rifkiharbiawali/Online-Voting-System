<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voting - Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
    <style>
        .login-continer {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {

            max-width: 450px;
            max-height: 400px;
            width: 100%;
            padding: 2rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>

<body>
    <div class="container login-continer">
        <div class="card login-card">
            <div class="card-body">
                <h4 class="card-title text-center text-danger">
                    <?= session()->getFlashdata('psn') ?>
                </h4>
                <form action="/auth/login" method="post">
                    <div class="form-floating mb-3">
                        <input name="username" id="username" type="text" class="form-control" placeholder="NIK"
                            required>
                        <label for="username">NIK</label>
                    </div>

                    <div class="form-floating mb-3">
                        <input name="password" id="password" type="password" class="form-control" placeholder="password"
                            required>
                        <label for="password">Password</label>
                    </div>

                    <div class="d-grid">
                        <button class="btn btn-primary btn-lg" type="submit">Login</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>

</html>