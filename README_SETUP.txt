APNA CLINIC LOGIN SETUP
1. Existing clinic UI is retained. Login gate is added.
2. Create a separate Supabase project. Run supabase_setup.sql in SQL editor.
3. Create owner user in Supabase Authentication > Users; then run the commented owner INSERT with your actual email.
4. Paste Project URL and publishable/anon key (NEVER service_role) into config.js.
5. Upload updated files to GitHub repository root.
IMPORTANT: Existing patient/visit/payment data still uses browser localStorage. This version is NOT safe for real patient data or multi-tenant sharing. Admin invitation and feature permissions are not yet implemented; user suspension in profiles is a scaffold and needs server-enforced RLS on all clinical tables. Do not enter real records until data migration, RLS, access checks and audit logs are completed.
