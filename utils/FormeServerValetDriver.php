<?php

class FormeServerValetDriver extends WordPressValetDriver
{
    /**
     * Custom suffix for site path.
     *
     * @var string
     */
    const sitePathSuffix = '/public';

    /**
     * Determine if the driver serves the request.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return bool
     */
    public function serves($sitePath, $siteName, $uri)
    {
        return file_exists($sitePath . self::sitePathSuffix . '/wp-config.php');
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
        return parent::isStaticFile($sitePath . self::sitePathSuffix, $siteName, $uri);
    }

    /**
     * Get the fully resolved path to the application's front controller.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return string
     */
    public function frontControllerPath($sitePath, $siteName, $uri)
    {
        $_SERVER['SERVER_ADDR'] = '127.0.0.1';
        $_SERVER['SERVER_NAME'] = $_SERVER['HTTP_HOST'];
        
        return parent::frontControllerPath($sitePath . self::sitePathSuffix, $siteName, $uri);
    }
}