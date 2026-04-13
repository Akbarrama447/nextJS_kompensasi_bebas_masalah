import { redirect } from 'next/navigation';

export default function RootPage() {
  // Logic pengalihan murni. Middleware akan mengambil peran 
  // untuk menentukan apakah lari ke /login atau /dashboard
  redirect('/dashboard');
}
