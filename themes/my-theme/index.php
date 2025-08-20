<?php
/**
 * The main template file
 *
 * @package My_Theme
 */

get_header(); ?>

<main id="main" class="site-main">
    <div class="container">
        <?php if (have_posts()) : ?>
            <div class="posts-grid">
                <?php while (have_posts()) : the_post(); ?>
                    <article id="post-<?php the_ID(); ?>" <?php post_class('post'); ?>>
                        <header class="entry-header">
                            <?php if (is_singular()) : ?>
                                <h1 class="entry-title"><?php the_title(); ?></h1>
                            <?php else : ?>
                                <h2 class="entry-title">
                                    <a href="<?php the_permalink(); ?>" rel="bookmark">
                                        <?php the_title(); ?>
                                    </a>
                                </h2>
                            <?php endif; ?>
                            
                            <div class="entry-meta">
                                <span class="posted-on">
                                    <?php echo get_the_date(); ?>
                                </span>
                                <span class="byline">
                                    <?php echo get_the_author(); ?>
                                </span>
                            </div>
                        </header>

                        <div class="entry-content">
                            <?php if (is_singular()) : ?>
                                <?php the_content(); ?>
                            <?php else : ?>
                                <?php the_excerpt(); ?>
                                <a href="<?php the_permalink(); ?>" class="read-more">
                                    Weiterlesen →
                                </a>
                            <?php endif; ?>
                        </div>
                    </article>
                <?php endwhile; ?>
            </div>

            <?php
            // Pagination
            the_posts_pagination(array(
                'mid_size' => 2,
                'prev_text' => '← Vorherige',
                'next_text' => 'Nächste →',
            ));
            ?>

        <?php else : ?>
            <div class="no-posts">
                <h2>Keine Beiträge gefunden</h2>
                <p>Entschuldigung, aber es wurden keine Beiträge gefunden.</p>
            </div>
        <?php endif; ?>
    </div>
</main>

<?php get_footer(); ?>
