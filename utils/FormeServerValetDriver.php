<?php

namespace Valet\Drivers\Custom;

use Valet\Drivers\Specific\WordPressValetDriver;

class FormeServerValetDriver extends WordPressValetDriver
{
    /**
     * Custom suffix for site path.
     *
     * @var string
     */
    const SITE_PATH_SUFFIX = '/public';

    /**
     * Determine if the driver serves the request.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return bool
     */
    public function serves(string $sitePath, string $siteName, string $uri): bool
    {
        return file_exists($sitePath . self::SITE_PATH_SUFFIX . '/wp-config.php');
    }

    /**
     * Determine if the incoming request is for a static file.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return string|false
     */
    public function isStaticFile($sitePath, $siteName, $uri)
    {
        return parent::isStaticFile($sitePath . self::SITE_PATH_SUFFIX, $siteName, $uri);
    }

    /**
     * Get the fully resolved path to the application's front controller.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return string
     */
    public function frontControllerPath(string $sitePath, string $siteName, string $uri): ?string
    {
        $_SERVER['SERVER_ADDR'] = '127.0.0.1';
        $_SERVER['SERVER_NAME'] = $_SERVER['HTTP_HOST'];

        return parent::frontControllerPath($sitePath . self::SITE_PATH_SUFFIX, $siteName, $uri);
    }
}
