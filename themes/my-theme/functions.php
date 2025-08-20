<?php
/**
 * My Theme functions and definitions
 *
 * @package My_Theme
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

/**
 * Theme setup
 */
function my_theme_setup() {
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
    add_theme_support('custom-logo');
    add_theme_support('customize-selective-refresh-widgets');

    // Register navigation menus
    register_nav_menus(array(
        'primary' => esc_html__('Primary Menu', 'my-theme'),
        'footer'  => esc_html__('Footer Menu', 'my-theme'),
    ));
}
add_action('after_setup_theme', 'my_theme_setup');

/**
 * Enqueue scripts and styles
 */
function my_theme_scripts() {
    wp_enqueue_style('my-theme-style', get_stylesheet_uri(), array(), '1.0.0');
    
    if (is_singular() && comments_open() && get_option('thread_comments')) {
        wp_enqueue_script('comment-reply');
    }
}
add_action('wp_enqueue_scripts', 'my_theme_scripts');

/**
 * Fallback menu function
 */
function my_theme_fallback_menu() {
    echo '<ul id="primary-menu" class="menu">';
    echo '<li><a href="' . home_url('/') . '">Startseite</a></li>';
    echo '<li><a href="' . home_url('/?page_id=2') . '">Über uns</a></li>';
    echo '<li><a href="' . home_url('/?page_id=3') . '">Kontakt</a></li>';
    echo '</ul>';
}

/**
 * Add custom image sizes
 */
function my_theme_image_sizes() {
    add_image_size('featured-large', 1200, 600, true);
    add_image_size('featured-medium', 600, 400, true);
    add_image_size('featured-small', 300, 200, true);
}
add_action('after_setup_theme', 'my_theme_image_sizes');

/**
 * Custom excerpt length
 */
function my_theme_excerpt_length($length) {
    return 20;
}
add_filter('excerpt_length', 'my_theme_excerpt_length');

/**
 * Custom excerpt more
 */
function my_theme_excerpt_more($more) {
    return '...';
}
add_filter('excerpt_more', 'my_theme_excerpt_more');

/**
 * Add custom body classes
 */
function my_theme_body_classes($classes) {
    // Add class for single posts
    if (is_single()) {
        $classes[] = 'single-post';
    }
    
    // Add class for pages
    if (is_page()) {
        $classes[] = 'single-page';
    }
    
    return $classes;
}
add_filter('body_class', 'my_theme_body_classes');

/**
 * Security: Remove WordPress version from head
 */
remove_action('wp_head', 'wp_generator');

/**
 * Security: Disable XML-RPC
 */
add_filter('xmlrpc_enabled', '__return_false');

/**
 * Performance: Remove unnecessary WordPress features
 */
function my_theme_disable_emojis() {
    remove_action('wp_head', 'print_emoji_detection_script', 7);
    remove_action('admin_print_scripts', 'print_emoji_detection_script');
    remove_action('wp_print_styles', 'print_emoji_styles');
    remove_action('admin_print_styles', 'print_emoji_styles');
    remove_filter('the_content_feed', 'wp_staticize_emoji');
    remove_filter('comment_text_rss', 'wp_staticize_emoji');
    remove_filter('wp_mail', 'wp_staticize_emoji_for_email');
}
add_action('init', 'my_theme_disable_emojis');
