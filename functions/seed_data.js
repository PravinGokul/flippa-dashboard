const admin = require('firebase-admin');

// 1. Connect to Emulators
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = 'localhost:9099';

admin.initializeApp({
  projectId: 'flippa-18c94', // Match your firebase.json/main.dart
});

const db = admin.firestore();
const auth = admin.auth();

const CATEGORIES = ['Fiction', 'Non-Fiction', 'Science', 'History', 'Biography', 'Technology'];
const CONDITIONS = ['New', 'Like New', 'Good', 'Fair'];
const TITLES = [
  'The Great Gatsby', '1984', 'To Kill a Mockingbird', 'The Catcher in the Rye', 
  'Brave New World', 'Sapiens', 'Educated', 'The Silent Patient', 'Project Hail Mary', 
  'The Midnight Library', 'Atomic Habits', 'Thinking, Fast and Slow', 'Dune',
  'Foundation', 'Hyperion', 'Neuromancer', 'Snow Crash', 'The Alchemist'
];
const AUTHORS = ['F. Scott Fitzgerald', 'George Orwell', 'Harper Lee', 'J.D. Salinger', 'Aldous Huxley', 'Yuval Noah Harari', 'Tara Westover'];

async function seedData() {
  console.log('🚀 Starting Seeding Process...');

  // 1.5 Clear Existing Listings for a fresh start
  console.log('🧹 Clearing existing listings...');
  const listingsRef = db.collection('listings');
  const snapshot = await listingsRef.get();
  const batch = db.batch();
  snapshot.docs.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();

  const users = [];
  const numUsers = 100;
  const numListings = 550;

  // 2. Create Users
  console.log(`👤 Creating ${numUsers} users...`);
  for (let i = 1; i <= numUsers; i++) {
    const email = `user${i}@flippa.test`;
    const password = 'password123';
    const displayName = `Test User ${i}`;
    const role = i % 5 === 0 ? 'seller' : 'consumer'; // 20% sellers

    try {
      const userRecord = await auth.createUser({
        email,
        password,
        displayName,
      });

      // Set Custom Claims (Roles)
      await auth.setCustomUserClaims(userRecord.uid, { role });

      // Create User Document in Firestore
      await db.collection('users').doc(userRecord.uid).set({
        email,
        displayName,
        role,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        trustScore: 4.5,
      });

      users.push({ uid: userRecord.uid, role });
    } catch (error) {
      console.error(`Failed to create user ${email}:`, error.message);
    }
  }

  // 3. Create Listings
  console.log(`📚 Creating ${numListings} listings...`);
  const sellers = users.filter(u => u.role === 'seller');
  const SECTIONS = ['trending', 'new_releases', 'local_authors'];
  
  for (let i = 1; i <= numListings; i++) {
    const seller = sellers[Math.floor(Math.random() * sellers.length)];
    const titleBase = TITLES[Math.floor(Math.random() * TITLES.length)];
    const title = `${titleBase} - Edition ${i}`;
    const author = AUTHORS[Math.floor(Math.random() * AUTHORS.length)];
    const category = CATEGORIES[Math.floor(Math.random() * CATEGORIES.length)];
    const condition = CONDITIONS[Math.floor(Math.random() * CONDITIONS.length)];
    const price = 10 + Math.floor(Math.random() * 90);
    const section = SECTIONS[i % SECTIONS.length];

    const listingData = {
      title,
      author,
      category,
      condition,
      selling_price: price, // Matches ListingModel.fromJson
      original_price: price + 20,
      price_rent_daily: price * 0.1,
      owner_id: seller.uid, // Matches ListingModel.fromJson
      is_available_for_sale: true,
      is_available_for_rent: true,
      rating: 4.0 + (Math.random() * 1.0),
      rating_count: Math.floor(Math.random() * 100),
      section: section, // CRITICAL for UI visibility
      description: `This is a high-quality copy of ${title}. Perfect for students and readers.`,
      image: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=400',
      created_at: new Date().toISOString(),
    };

    try {
      const docRef = await db.collection('listings').add(listingData);
      // Ensure 'id' field matches doc ID if ListingModel expects it (it does in some factories)
      await docRef.update({ id: docRef.id });
    } catch (error) {
      console.error(`Failed to create listing ${i}:`, error.message);
    }
    
    if (i % 50 === 0) console.log(`... ${i} listings created`);
  }

  console.log('✅ Seeding Complete!');
  process.exit(0);
}

seedData();
