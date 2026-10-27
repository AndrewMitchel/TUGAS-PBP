
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return Response.json(
      { error: "Method not allowed." },
      { status: 405, headers: corsHeaders },
    );
  }

  const authorization = req.headers.get("Authorization");

  if (!authorization?.startsWith("Bearer ")) {
    return Response.json(
      { error: "Token autentikasi tidak ditemukan." },
      { status: 401, headers: corsHeaders },
    );
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("MY_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !anonKey || !serviceRoleKey) {
    return Response.json(
      { error: "Konfigurasi server belum lengkap." },
      { status: 500, headers: corsHeaders },
    );
  }

  const token = authorization.substring("Bearer ".length);

  const authClient = createClient(supabaseUrl, anonKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });

  const {
    data: { user },
    error: authError,
  } = await authClient.auth.getUser(token);

  if (authError || !user) {
    return Response.json(
      { error: "Sesi tidak valid. Silakan login kembali." },
      { status: 401, headers: corsHeaders },
    );
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });

  try {
    const userId = user.id;

    const { error: favoritesError } = await admin
      .from("user_favorites")
      .delete()
      .eq("user_id", userId);

    if (favoritesError) throw favoritesError;

    const { error: recentError } = await admin
      .from("user_recently_viewed")
      .delete()
      .eq("user_id", userId);

    if (recentError) throw recentError;

    async function deleteAvatarFolder(
      folder: string,
    ): Promise<void> {
      const { data, error } = await admin.storage
        .from("avatars")
        .list(folder, { limit: 1000 });

      if (error) throw error;

      const filesToDelete: string[] = [];

      for (const item of data ?? []) {
        const path = `${folder}/${item.name}`;

        if (item.id === null) {
          await deleteAvatarFolder(path);
        } else {
          filesToDelete.push(path);
        }
      }

      if (filesToDelete.length > 0) {
        const { error: removeError } = await admin.storage
          .from("avatars")
          .remove(filesToDelete);

        if (removeError) throw removeError;
      }
    }

    await deleteAvatarFolder(userId);

    const { error: profileError } = await admin
      .from("profiles")
      .delete()
      .eq("id", userId);

    if (profileError) throw profileError;

    const { error: deleteUserError } =
      await admin.auth.admin.deleteUser(userId);

    if (deleteUserError) throw deleteUserError;

    return Response.json(
      {
        success: true,
        message: "Akun berhasil dihapus.",
      },
      { status: 200, headers: corsHeaders },
    );
  } catch (error) {
    console.error("Delete account failed:", error);

    return Response.json(
      {
        error: error instanceof Error
          ? error.message
          : "Gagal menghapus akun.",
      },
      { status: 500, headers: corsHeaders },
    );
  }
});
