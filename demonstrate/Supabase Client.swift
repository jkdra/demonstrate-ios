//
//  Supabase Client.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/9/24.
//

import Foundation
import Supabase

let devSupabase = SupabaseClient(
    supabaseURL: URL(string: "http://127.0.0.1:54321")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0"
)

let supabase = SupabaseClient(supabaseURL: URL(string: "https://tcratutdtunzzyyzylwe.supabase.co")!,
                              supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjcmF0dXRkdHVuenp5eXp5bHdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUzMjMwMTgsImV4cCI6MjAzMDg5OTAxOH0.JV5tnFSy4xm7wxh-LaulKqUFwWkTyqGHaYOfNOZDz8c")

let database = devSupabase.schema("public")
let auth = devSupabase.auth
