const admin = require('firebase-admin');

process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';

admin.initializeApp({ projectId: 'flippa-18c94' });

const db = admin.firestore();
const auth = admin.auth();

const CATEGORIES = ['Fiction', 'Non-Fiction', 'Science', 'History', 'Biography', 'Technology'];
const CONDITIONS = ['New', 'Like New', 'Good', 'Fair'];
const SECTIONS = ['trending', 'new_releases', 'local_authors'];
const TITLES = [
  'The Great Gatsby', '1984', 'To Kill a Mockingbird', 'Atomic Habits',
  'Sapiens', 'The Alchemist', 'Educated', 'Dune', 'Foundation',
  'Thinking Fast and Slow', 'Project Hail Mary', 'The Midnight Library',
  'Snow Crash', 'Neuromancer', 'Hyperion'
];
const AUTHORS = ['George Orwell', 'Harper Lee', 'James Clear', 'Yuval Noah Harari',
  'Tara Westover', 'Frank Herbert', 'Isaac Asimov'];

async function seedListings() {
  console.log('📚 Seeding listings...');

  // Fetch existing seller UIDs from Firestore
  const usersSnap = await db.collection('users').where('role', '==', 'seller').get();
  if (usersSnap.empty) {
    console.error('❌ No sellers found in Firestore! Run the full seed_data.js first.');
    process.exit(1);
  }
  const sellerIds = usersSnap.docs.map(d => d.id);
  console.log(`Found ${sellerIds.length} sellers.`);

  // Clear existing listings
  const existing = await db.collection('listings').get();
  const batch = db.batch();
  existing.docs.forEach(d => batch.delete(d.ref));
  await batch.commit();
  console.log('🧹 Cleared old listings.');

  const numListings = 550;
  for (let i = 1; i <= numListings; i++) {
    const sellerId = sellerIds[Math.floor(Math.random() * sellerIds.length)];
    const titleBase = TITLES[Math.floor(Math.random() * TITLES.length)];
    const price = 10 + Math.floor(Math.random() * 90);

    const data = {
      title: `${titleBase} - Edition ${i}`,
      author: AUTHORS[Math.floor(Math.random() * AUTHORS.length)],
      category: CATEGORIES[Math.floor(Math.random() * CATEGORIES.length)],
      condition: CONDITIONS[Math.floor(Math.random() * CONDITIONS.length)],
      selling_price: price,
      original_price: price + 20,
      price_rent_daily: parseFloat((price * 0.1).toFixed(2)),
      owner_id: sellerId,
      is_available_for_sale: true,
      is_available_for_rent: true,
      rating: parseFloat((4.0 + Math.random()).toFixed(1)),
      rating_count: Math.floor(Math.random() * 100),
      section: SECTIONS[i % SECTIONS.length],
      description: `A fantastic read. ${titleBase} - Edition ${i}.`,
      image: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400',
      created_at: new Date().toISOString(),
    };

    const ref = await db.collection('listings').add(data);
    await ref.update({ id: ref.id });

    if (i % 50 === 0) console.log(`... ${i}/${numListings} listings created`);
  }

  console.log('✅ Done! 550 listings seeded.');
  process.exit(0);
}

seedListings();
