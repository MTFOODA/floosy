# Profile saving and analytics layout

The profile save on the device returned `PGRST116`: an update followed by
`single()` received zero rows. Older accounts can lack a profile row, and the
schema previously granted users SELECT/UPDATE policies but no INSERT policy.

Profile saving now upserts the signed-in owner's ID, name and contact phone.
It preserves existing preferences and does not write the authentication email.
Apply [the idempotent SQL patch](../supabase/patches/repair_profile_save.sql) in
the project's SQL Editor to allow authenticated users to insert their own row.
The final query confirms the INSERT ownership policy. The complete schema also
includes this policy for new installations.

The editor waits for the profile to load before initializing fields and retains
its email controller until disposal. A failed save keeps the entered values
and shows a specific save-failure message.

Analytics summary cards use content-driven heights instead of a fixed grid
aspect ratio. The category chart places its legend below the chart on narrow
screens or with large text. The empty state can also grow with its contents.

Regression tests cover Arabic analytics at widths 320, 360 and 430 with text
scales 1, 1.3 and 2; asynchronous profile loading; missing/existing profile saves;
read-back/retry; retained preferences; and rejection of unauthenticated or
different-owner writes. Device verification requires saving a profile, reopening
the editor, and checking analytics after installing the update.

Verification: all 415 project tests passed and `flutter analyze` reported no
issues. The Android update was installed with `adb install -r`. After applying
the SQL patch, the user confirmed that saving succeeds, name/phone remain when
reopening the editor, and the analytics overflow markers are gone.
