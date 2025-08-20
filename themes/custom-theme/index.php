<?php get_header(); ?>

<div class="container">
    <h1><?php bloginfo('name'); ?></h1>
    
    <div class="content">
        <?php if (have_posts()) : ?>
            <?php while (have_posts()) : the_post(); ?>
                <article>
                    <h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
                    <div class="entry-content">
                        <?php the_excerpt(); ?>
                    </div>
                </article>
            <?php endwhile; ?>
        <?php else : ?>
            <p>Keine Beiträge gefunden.</p>
        <?php endif; ?>
    </div>
</div>

<?php get_footer(); ?>
