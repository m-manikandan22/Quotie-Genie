document.addEventListener('DOMContentLoaded', () => {

    // Navbar Scroll Effect
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // Intersection Observer for Scroll Animations
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.fade-in-up, .slide-in-right').forEach(el => {
        observer.observe(el);
    });

    // Carousel Logic
    const images = document.querySelectorAll('.carousel-img');
    const dots = document.querySelectorAll('.dot');
    let currentSlide = 0;
    let slideInterval;

    function showSlide(index) {
        images.forEach(img => img.classList.remove('active'));
        dots.forEach(dot => dot.classList.remove('active'));
        
        images[index].classList.add('active');
        dots[index].classList.add('active');
        currentSlide = index;
    }

    function nextSlide() {
        let newIndex = (currentSlide + 1) % images.length;
        showSlide(newIndex);
    }

    function startSlide() {
        slideInterval = setInterval(nextSlide, 4000);
    }

    dots.forEach((dot, index) => {
        dot.addEventListener('click', () => {
            clearInterval(slideInterval);
            showSlide(index);
            startSlide();
        });
    });

    startSlide();

    // Mock Data for Search
    const knowledgeBase = [
        { title: "How to update your billing information", desc: "Step-by-step guide to changing your credit card or invoice details." },
        { title: "API Rate Limits", desc: "Understand our API rate limits and how to request quota increases." },
        { title: "Managing User Permissions", desc: "Learn how to assign roles and manage access for your team members." },
        { title: "Integration with Slack", desc: "Connect our platform with your Slack workspace for real-time notifications." },
        { title: "Data Export & Compliance", desc: "How to export your data and information regarding GDPR compliance." }
    ];

    // Search Functionality
    const searchInput = document.getElementById('searchInput');
    const searchResults = document.getElementById('searchResults');
    let searchTimeout;

    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        
        clearTimeout(searchTimeout);
        
        if (query.length < 2) {
            searchResults.classList.remove('active');
            setTimeout(() => { searchResults.innerHTML = ''; }, 300);
            return;
        }

        // Simulate network request
        searchTimeout = setTimeout(() => {
            const results = knowledgeBase.filter(item => 
                item.title.toLowerCase().includes(query) || 
                item.desc.toLowerCase().includes(query)
            );

            if (results.length > 0) {
                const html = results.map(item => `
                    <div class="result-item">
                        <div class="result-title">${item.title}</div>
                        <p class="result-desc">${item.desc}</p>
                    </div>
                `).join('');
                searchResults.innerHTML = html;
            } else {
                searchResults.innerHTML = `
                    <div class="result-item">
                        <div class="result-title" style="color: var(--text-secondary)">No results found for "${query}"</div>
                    </div>
                `;
            }
            
            searchResults.style.display = 'block';
            // Trigger reflow
            void searchResults.offsetWidth;
            searchResults.classList.add('active');
        }, 300);
    });

    // Close search results when clicking outside
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.search-container')) {
            searchResults.classList.remove('active');
        }
    });

    // FAQ Accordion
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        item.addEventListener('click', () => {
            const isActive = item.classList.contains('active');
            // Close all
            faqItems.forEach(faq => faq.classList.remove('active'));
            // Toggle current
            if (!isActive) {
                item.classList.add('active');
            }
        });
    });

    // Contact Form Submission
    const contactForm = document.getElementById('contactForm');
    const submitBtn = document.getElementById('submitBtn');
    const formFeedback = document.getElementById('formFeedback');

    contactForm.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const name = document.getElementById('name').value;
        const email = document.getElementById('email').value;
        const message = document.getElementById('message').value;
        
        // Button loading state
        submitBtn.classList.add('btn-loading');
        submitBtn.disabled = true;
        formFeedback.classList.add('hidden');

        // Simulate API check/processing
        setTimeout(() => {
            submitBtn.classList.remove('btn-loading');
            submitBtn.disabled = false;
            
            const subject = encodeURIComponent("Support Request from " + name);
            const body = encodeURIComponent("Name: " + name + "\nEmail: " + email + "\n\nMessage:\n" + message);
            window.location.href = `mailto:mmanikandan0005@gmail.com?subject=${subject}&body=${body}`;
            
            contactForm.reset();
            
            formFeedback.textContent = "Redirecting to your email client...";
            formFeedback.style.color = "#000";
            formFeedback.style.borderColor = "rgba(0,0,0,0.2)";
            formFeedback.classList.remove('hidden');
            
            setTimeout(() => {
                formFeedback.classList.add('hidden');
            }, 5000);
        }, 800);
    });
});
