<?php

declare(strict_types=1);

namespace asv2108\docker;

use PDO;
use PDOException;

final class PostgresPdo
{
    public function index()
    {
        try {
            $connection = new PDO('pgsql:host=docker-db;port=5432;dbname=test_db;user=postgres;password=password');
        } catch (PDOException $e) {
            print "Error!: " . $e->getMessage();
            die();
        }

        var_dump($connection);
    }
}
