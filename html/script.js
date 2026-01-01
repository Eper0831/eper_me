const container = document.getElementById('container');
const bubbles = {};

// Ikon kulcsszavak és definíciók
const iconKeywords = {
    'telefon': '<i class="fa-solid fa-mobile-screen"></i>',
    'hív': '<i class="fa-solid fa-phone"></i>',
    'sms': '<i class="fa-solid fa-comments"></i>',
    'eszik': '<i class="fa-solid fa-burger"></i>',
    'iszik': '<i class="fa-solid fa-glass-water"></i>',
    'fegyver': '<i class="fa-solid fa-gun"></i>',
    'pisztoly': '<i class="fa-solid fa-gun"></i>',
    'autó': '<i class="fa-solid fa-car"></i>',
    'kocsi': '<i class="fa-solid fa-car"></i>',
    'jármű': '<i class="fa-solid fa-car"></i>',
    'kulcs': '<i class="fa-solid fa-key"></i>',
    'cigi': '<i class="fa-solid fa-smoking"></i>',
    'dohány': '<i class="fa-solid fa-smoking"></i>',
    'kártya': '<i class="fa-solid fa-id-card"></i>',
    'igazolvány': '<i class="fa-solid fa-id-card"></i>',
    'rádió': '<i class="fa-solid fa-walkie-talkie"></i>',
    'szar': '<i class="fa-solid fa-poop"></i>',
    'szarik': '<i class="fa-solid fa-poop"></i>'
};

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'addMessage') {
        // Itt adjuk át a data.icon-t a függvénynek
        createBubble(data.id, data.text, data.type, data.icon);
    } 
    else if (data.action === 'removeMessage') {
        removeBubble(data.id);
    } 
    else if (data.action === 'updatePositions') {
        updatePositions(data.updates);
    }
});

function createBubble(id, text, type, defaultIcon) {
    const div = document.createElement('div');
    div.classList.add('bubble');
    
    if (type) {
        div.classList.add(type);
    }
    
    let finalIcon = defaultIcon; 
    
    const lowerText = text.toLowerCase();
    for (const [key, iconHtml] of Object.entries(iconKeywords)) {
        if (lowerText.includes(key)) {
            finalIcon = iconHtml;
            break; 
        }
    }

    // HIBA JAVÍTVA: Itt korábban 'icon'-t vizsgáltunk, most már 'finalIcon'-t
    if (finalIcon && finalIcon !== '') {
        div.innerHTML = `<span style="margin-right: 6px;">${finalIcon}</span> ${text}`;
    } else {
        div.innerHTML = text;
    }

    container.appendChild(div);
    bubbles[id] = div;
}

function removeBubble(id) {
    const el = bubbles[id];
    if (el) {
        el.style.opacity = '0';
        el.style.transform = 'translate(-50%, -150%) scale(0.8)';
        
        setTimeout(() => {
            if (el.parentNode) el.parentNode.removeChild(el);
            delete bubbles[id];
        }, 300);
    }
}

function updatePositions(updates) {
    updates.forEach(update => {
        const el = bubbles[update.id];
        if (el) {
            if (update.visible) {
                el.style.display = 'block';
                el.style.left = (update.x * 100) + '%';
                el.style.top = (update.y * 100) + '%';
                el.style.transform = `translate(-50%, -100%) scale(${update.scale})`;
                
                // Távolság alapú elhalványulás
                let calculatedOpacity = Math.max(0.4, update.scale); 
                el.style.opacity = calculatedOpacity;
                
            } else {
                el.style.display = 'none';
            }
        }
    });
}