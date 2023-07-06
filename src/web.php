<?php

declare(strict_types=1);

use asv2108\docker\PostgresPdo;

echo 'Hello world docker';

$pdo = new PostgresPdo();
$pdo->index();