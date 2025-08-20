#!/bin/bash

# WordPress Docker Development Setup - New Project Initializer
# Usage: ./setup-new-project.sh "Project Name" "domain.com"

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if project name and domain are provided
if [ $# -ne 2 ]; then
    echo -e "${RED}❌ Usage: $0 \"Project Name\" \"domain.com\"${NC}"
    echo -e "${YELLOW}Example: $0 \"My Awesome Website\" \"mywebsite.com\"${NC}"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DOMAIN="$2"
PROJECT_SLUG=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-\|-$//g')

echo -e "${BLUE}🚀 Setting up new WordPress project: $PROJECT_NAME${NC}"
echo -e "${BLUE}🌐 Domain: $PROJECT_DOMAIN${NC}"
echo -e "${BLUE}📁 Project slug: $PROJECT_SLUG${NC}"
echo ""

# Create .env file from template
if [ ! -f .env ]; then
    echo -e "${YELLOW}📝 Creating .env file...${NC}"
    cp env.example .env
    
    # Update .env with project-specific values
    sed -i.bak "s/My WordPress Site/$PROJECT_NAME/g" .env
    sed -i.bak "s/yourdomain.com/$PROJECT_DOMAIN/g" .env
    sed -i.bak "s/my-theme/$PROJECT_SLUG-theme/g" .env
    
    # Generate secure passwords
    DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    ADMIN_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
    
    sed -i.bak "s/wp_password/$DB_PASSWORD/g" .env
    sed -i.bak "s/secure_password_123/$ADMIN_PASSWORD/g" .env
    
    # Clean up backup files
    rm .env.bak
    
    echo -e "${GREEN}✅ .env file created with secure passwords${NC}"
else
    echo -e "${YELLOW}⚠️  .env file already exists, skipping...${NC}"
fi

# Rename theme directory
if [ -d "themes/my-theme" ]; then
    echo -e "${YELLOW}🎨 Renaming theme directory...${NC}"
    mv themes/my-theme "themes/$PROJECT_SLUG-theme"
    echo -e "${GREEN}✅ Theme directory renamed to: themes/$PROJECT_SLUG-theme${NC}"
fi

# Update theme files with project info
if [ -d "themes/$PROJECT_SLUG-theme" ]; then
    echo -e "${YELLOW}📝 Updating theme files...${NC}"
    
    # Update style.css
    sed -i.bak "s/My Custom Theme/$PROJECT_NAME/g" "themes/$PROJECT_SLUG-theme/style.css"
    sed -i.bak "s/Your Name/$(whoami)/g" "themes/$PROJECT_SLUG-theme/style.css"
    sed -i.bak "s/https:\/\/yourwebsite.com/https:\/\/$PROJECT_DOMAIN/g" "themes/$PROJECT_SLUG-theme/style.css"
    
    # Update functions.php
    sed -i.bak "s/My_Theme/${PROJECT_SLUG^}_Theme/g" "themes/$PROJECT_SLUG-theme/functions.php"
    sed -i.bak "s/my-theme/$PROJECT_SLUG-theme/g" "themes/$PROJECT_SLUG-theme/functions.php"
    
    # Clean up backup files
    rm "themes/$PROJECT_SLUG-theme/"*.bak
    
    echo -e "${GREEN}✅ Theme files updated${NC}"
fi

# Update docker-compose.yml with new theme path
if [ -d "themes/$PROJECT_SLUG-theme" ]; then
    echo -e "${YELLOW}🐳 Updating Docker configuration...${NC}"
    sed -i.bak "s/themes\/my-theme/themes\/$PROJECT_SLUG-theme/g" docker-compose.yml
    rm docker-compose.yml.bak
    echo -e "${GREEN}✅ Docker configuration updated${NC}"
fi

# Create initial content
echo -e "${YELLOW}📄 Creating initial pages...${NC}"
mkdir -p "themes/$PROJECT_SLUG-theme/template-parts"

# Create page templates
cat > "themes/$PROJECT_SLUG-theme/page-about.php" << 'EOF'
<?php
/**
 * Template Name: Über uns
 */

get_header(); ?>

<main class="site-main">
    <div class="container">
        <article class="page">
            <header class="entry-header">
                <h1 class="entry-title"><?php the_title(); ?></h1>
            </header>
            
            <div class="entry-content">
                <?php while (have_posts()) : the_post(); ?>
                    <?php the_content(); ?>
                <?php endwhile; ?>
            </div>
        </article>
    </div>
</main>

<?php get_footer(); ?>
EOF

cat > "themes/$PROJECT_SLUG-theme/page-contact.php" << 'EOF'
<?php
/**
 * Template Name: Kontakt
 */

get_header(); ?>

<main class="site-main">
    <div class="container">
        <article class="page">
            <header class="entry-header">
                <h1 class="entry-title"><?php the_title(); ?></h1>
            </header>
            
            <div class="entry-content">
                <div class="contact-info">
                    <h2>Kontaktieren Sie uns</h2>
                    <p>Wir freuen uns auf Ihre Nachricht!</p>
                    
                    <div class="contact-details">
                        <p><strong>Email:</strong> info@<?php echo str_replace('www.', '', $_SERVER['HTTP_HOST']); ?></p>
                        <p><strong>Telefon:</strong> +49 123 456789</p>
                        <p><strong>Adresse:</strong> Musterstraße 123, 12345 Musterstadt</p>
                    </div>
                </div>
                
                <?php while (have_posts()) : the_post(); ?>
                    <?php the_content(); ?>
                <?php endwhile; ?>
            </div>
        </article>
    </div>
</main>

<?php get_footer(); ?>
EOF

echo -e "${GREEN}✅ Initial page templates created${NC}"

# Create README for the project
cat > PROJECT_README.md << EOF
# $PROJECT_NAME

## 🚀 Quick Start

1. **Environment Setup:**
   \`\`\`bash
   # .env file is already configured
   # Check and adjust settings if needed
   \`\`\`

2. **Start Development:**
   \`\`\`bash
   task up:build
   \`\`\`

3. **Access WordPress:**
   - Frontend: http://localhost:8000
   - Admin: http://localhost:8000/wp-admin
   - Admin Login: Check .env file

## 📁 Project Structure

- \`themes/$PROJECT_SLUG-theme/\` - Your WordPress theme
- \`media/\` - Uploads and media files
- \`docker-compose.yml\` - Docker services configuration

## 🎨 Theme Development

Your theme is located in \`themes/$PROJECT_SLUG-theme/\`

### Key Files:
- \`style.css\` - Main stylesheet
- \`index.php\` - Main template
- \`header.php\` - Header template
- \`footer.php\` - Footer template
- \`functions.php\` - Theme functions
- \`page-about.php\` - About page template
- \`page-contact.php\` - Contact page template

## 🚀 Deployment

This project is configured for automatic deployment to IONOS via GitHub Actions.

### Setup GitHub Secrets:
- \`IONOS_USERNAME\` - Your IONOS username
- \`IONOS_PASSWORD\` - Your IONOS password
- \`IONOS_HOST\` - IONOS server hostname
- \`DEPLOY_PATH\` - Target directory on server
- \`WEBSITE_URL\` - Your website URL

### Deploy:
- Push to \`main\` branch for automatic deployment
- Or manually trigger via GitHub Actions

## 🔧 Development Commands

\`\`\`bash
task up              # Start containers
task down            # Stop containers
task restart         # Restart containers
task logs            # Show logs
task wpshell         # WordPress shell
task backup          # Database backup
\`\`\`

## 📝 Next Steps

1. Customize your theme in \`themes/$PROJECT_SLUG-theme/\`
2. Add your content via WordPress admin
3. Configure GitHub Secrets for deployment
4. Push to main branch for first deployment

---

**Project:** $PROJECT_NAME  
**Domain:** $PROJECT_DOMAIN  
**Created:** $(date)
EOF

echo -e "${GREEN}✅ Project README created${NC}"

# Final instructions
echo ""
echo -e "${GREEN}🎉 Project setup completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "1. ${YELLOW}Review and adjust .env file if needed${NC}"
echo -e "2. ${YELLOW}Start development: task up:build${NC}"
echo -e "3. ${YELLOW}Access WordPress at: http://localhost:8000${NC}"
echo -e "4. ${YELLOW}Admin login: Check .env file for credentials${NC}"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo -e "- Project README: PROJECT_README.md"
echo -e "- WordPress Admin: http://localhost:8000/wp-admin"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
