import uuid
import random
from faker import Faker

fake = Faker()

def generate_bulk_users(count=1000):
    print(f"Generating {count} synthetic users...")
    users = []
    for _ in range(count):
        users.append({
            "id": str(uuid.uuid4()),
            "email": fake.unique.email(),
            "display_name": fake.name(),
            "country_code": fake.country_code(),
            "role": random.choice(["consumer", "individual_seller"]),
            "is_verified": fake.boolean(chance_of_getting_true=70)
        })
    return users

if __name__ == "__main__":
    # Example usage: Generate data and print first 5
    synthetic_data = generate_bulk_users(10)
    for user in synthetic_data[:5]:
        print(user)
    print("Done.")
