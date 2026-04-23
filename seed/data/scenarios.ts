/**
 * Investor-Grade Demo Scenarios for FLIPPA
 * These are hand-crafted data points to showcase platform features.
 */

export const DEMO_SCENARIOS = [
    {
        name: "Global B2B Leasing",
        story: "BerlinTech GmbH leases 50 MacBook Pros to a London Startup for 6 months.",
        features: ["B2B Org Management", "Multi-currency (EUR/GBP)", "Escrow Protection"],
        data: {
            seller: "BerlinTech GmbH",
            buyer: "LondonStartup Ltd",
            amount: "€25,000 Deposit",
            status: "ACTIVE_ESCROW_HELD"
        }
    },
    {
        name: "Trust & Dispute Resolution",
        story: "Construction drill rented in Mumbai, returned late with motor damage.",
        features: ["Rental Calendars", "Late Penalties", "Dispute Workflow"],
        data: {
            item: "Heavy Duty Core Drill",
            penalty: "15% Deposit Deduction",
            status: "DISPUTE_RESOLVED_PARTIAL_REFUND"
        }
    },
    {
        name: "Fleet Logistics (Enterprise)",
        story: "UAE Logistics firm manages a fleet of 20 forklifts via a specialized sub-org.",
        features: ["Enterprise Fleet Tiers", "Multi-user Permissions", "Recurring Monthly Billing"],
        data: {
            org: "Dubai Logistics Hub",
            items: "20x Toyota Forklift",
            billing: "Monthly Automated Invoice"
        }
    }
];
