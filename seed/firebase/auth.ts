import admin from "firebase-admin";

// Initialization is handled in the main run.ts or config
export async function createAuthUser(email: string, password: string, uid?: string) {
    try {
        return await admin.auth().createUser({
            uid: uid,
            email,
            password,
            emailVerified: true,
        });
    } catch (e: any) {
        if (e.code === "auth/email-already-exists" || e.code === "auth/uid-already-exists") {
            return await admin.auth().getUserByEmail(email);
        }
        throw e;
    }
}
