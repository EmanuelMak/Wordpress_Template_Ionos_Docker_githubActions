<?php
/**
 * Custom Theme Functions
 */

// Theme Setup
function custom_theme_setup() {
    // Add theme support for various features
    add_theme_support('title-tag');
    add_theme_support('post-thumbnails');
    add_theme_support('html5', array(
        'search-form',
        'comment-form',
        'comment-list',
        'gallery',
        'caption',
    ));
    
    // Register navigation menus
    register_nav_menus(array(
        'primary' => __('Primary Menu', 'custom-theme'),
    ));
}
add_action('after_setup_theme', 'custom_theme_setup');

// Enqueue scripts and styles
function custom_theme_scripts() {
    wp_enqueue_style('custom-theme-style', get_stylesheet_uri());
}
add_action('wp_enqueue_scripts', 'custom_theme_scripts');

// Custom excerpt length
function custom_excerpt_length($length) {
    return 20;
}
add_filter('excerpt_length', 'custom_excerpt_length');
