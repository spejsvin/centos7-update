# 🛠 Popravka CentOS repozitorijuma i azuriranje sistema

## 📌 Opis
Ova skripta automatski popravlja repozitorijume na CentOS 7 sistemima, azurira sistemske pakete i resava moguce probleme sa DNS podesavanjima.

## 🚀 Funkcionalnosti
- Kreira rezervnu kopiju postojecih repozitorijum fajlova ✅
- Brise stare i kreira nove repozitorijume 📂
- Cisti i regenerise YUM kes 🔄
- Azurira CA sertifikate 🔐
- Azurira sistemske pakete 📦
- Proverava i ispravlja DNS konfiguraciju 🌐
- Nudi opciju za restart sistema 🔄

## ⚠️ Napomena
Skripta mora da se pokrene sa root privilegijama. Ako nije pokrenuta kao root, nece raditi ispravno.

## 📖 Kako koristiti
1. Preuzmite skriptu na svoj CentOS sistem.
2. Dodelite dozvole za izvrsavanje:  
   ```bash
   chmod +x build.sh
   ```
3. Pokrenite je kao root:  
   ```bash
   sudo ./build.sh
   ```
4. Pratite instrukcije na ekranu.

## 📝 Autor
👨‍💻 Napravio: **spacevin**

