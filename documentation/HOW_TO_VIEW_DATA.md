# 📊 HOW TO VIEW YOUR APP DATA - Complete Guide

## 🎯 Overview

Your Elder Care Hostel app stores ALL data in **Supabase** (a cloud database). There are TWO ways to view your data:

1. **Supabase Dashboard** (Web-based - Recommended for full access)
2. **Admin Analytics Screen** (In-app - Quick overview)

---

## 🌐 METHOD 1: Supabase Dashboard (Most Powerful)

### Step 1: Access Supabase

1. Go to: https://supabase.com
2. Click **Sign In**
3. Login with your account
4. You'll see your project: **elder-care-hostel**
5. Click on it to open the dashboard

---

### Step 2: View User Accounts

**Navigation:** Left sidebar → **Authentication** → **Users**

#### What You'll See:
```
📧 Email Address    |  🔑 Role       |  📅 Created     |  ⚡ Status
--------------------------------------------------------------------
admin@eldercare.com | admin         | 2026-02-07     | ✅ Active
john@family.com     | customer      | 2026-02-08     | ✅ Active
mary@family.com     | customer      | 2026-02-08     | ✅ Active
```

#### Actions You Can Take:
- ✅ **View** all registered users
- ✅ **Search** by email
- ✅ **Edit** user information
- ✅ **Delete** users
- ✅ **Ban/Unban** users
- ✅ **Send** password reset emails
- ✅ **View** user metadata (role info)

#### How to Check User Role:
1. Click on any user
2. Scroll to **User Metadata** section
3. You'll see: `{"role": "admin"}` or `{"role": "customer"}`

---

### Step 3: View Residents Data

**Navigation:** Left sidebar → **Table Editor** → Select **residents** table

#### What You'll See:
```
Name          | Age | Gender | Room | Medical Conditions      | Status
-------------------------------------------------------------------------
John Smith    | 75  | Male   | 101  | Diabetes, Hypertension | active
Alice Johnson | 82  | Female | 102  | Arthritis              | active
Robert Brown  | 78  | Male   | 103  | Heart condition        | active
```

#### Actions You Can Take:
- ✅ **View** all residents
- ✅ **Add** new resident manually (click "+ Insert row")
- ✅ **Edit** resident information (click on cell)
- ✅ **Delete** residents (click "..." menu)
- ✅ **Export** data to CSV (top right button)
- ✅ **Filter** by status, age, etc.
- ✅ **Search** by name

---

### Step 4: View Visits (Booking Requests)

**Navigation:** Left sidebar → **Table Editor** → Select **visits** table

#### What You'll See:
```
Resident Name | Visitor Name | Phone       | Date       | Status
-------------------------------------------------------------------
John Smith    | Mary Smith   | 555-0101    | 2026-02-10 | pending
Alice Johnson | Bob Johnson  | 555-0102    | 2026-02-11 | approved
Robert Brown  | Sarah Brown  | 555-0103    | 2026-02-12 | completed
```

#### Actions You Can Take:
- ✅ **View** all visit requests
- ✅ **Filter** by status (pending, approved, completed, cancelled)
- ✅ **Edit** visit status manually
- ✅ **Export** visit data
- ✅ **See** visitor contact information
- ✅ **Track** visit purposes and special notes

---

### Step 5: View Services

**Navigation:** Left sidebar → **Table Editor** → Select **services** table

#### What You'll See:
```
Name                | Category      | Price    | Available
------------------------------------------------------------
24/7 Nursing Care   | medical       | $2500.00 | ✅ true
Physical Therapy    | medical       | $800.00  | ✅ true
Recreation          | recreational  | $300.00  | ✅ true
```

#### Actions You Can Take:
- ✅ **View** all services
- ✅ **Add** new services
- ✅ **Update** prices
- ✅ **Toggle** availability
- ✅ **Edit** descriptions

---

### Step 6: View Staff

**Navigation:** Left sidebar → **Table Editor** → Select **staff** table

#### What You'll See:
```
Name              | Role      | Shift    | Phone      | Active
------------------------------------------------------------------
Dr. Emily Wilson  | doctor    | morning  | 555-1001   | ✅ true
Nurse Jane Davis  | nurse     | morning  | 555-1002   | ✅ true
Mike Taylor       | nurse     | evening  | 555-1003   | ✅ true
```

---

### 📊 Additional Supabase Features

#### Real-time Monitoring
**Navigation:** Left sidebar → **Table Editor** → Enable "Realtime"
- See live updates as data changes
- Monitor who's using your app in real-time

#### SQL Editor
**Navigation:** Left sidebar → **SQL Editor**
- Run custom queries
- Generate reports
- Get advanced statistics

Example queries:
```sql
-- Count total users by role
SELECT 
  user_metadata->>'role' as role,
  COUNT(*) as count
FROM auth.users
GROUP BY user_metadata->>'role';

-- Get visit statistics
SELECT 
  status,
  COUNT(*) as count
FROM visits
GROUP BY status;

-- Get active residents count
SELECT COUNT(*) 
FROM residents 
WHERE status = 'active';
```

#### Export Data
1. Go to any table
2. Click "..." menu at top right
3. Select "Download as CSV"
4. Use in Excel or other tools

---

## 📱 METHOD 2: In-App Analytics (Quick View)

### Accessing Analytics Screen

1. **Login as Admin**
   - Email: `admin@eldercare.com`
   - Password: `admin123`

2. **From Admin Dashboard**
   - You'll see a new **Analytics** tile (teal color)
   - Click on it

3. **What You'll See:**
   - 📊 Total Residents count
   - ✅ Active Residents count
   - 📅 Total Visits count
   - 👥 Total Staff count
   - 🔄 Visit Status Breakdown (Pending, Approved, Completed)
   - 💊 Total Services Available

4. **Features:**
   - 🔄 Pull down to refresh
   - 📊 Real-time statistics
   - 🎨 Visual dashboard
   - 📈 Easy to understand metrics

---

## 📈 Understanding Your Data

### User Growth
**Where:** Supabase → Authentication → Users
- See how many people are registering
- Track admin vs customer accounts
- Monitor daily sign-ups

### Booking Trends
**Where:** Supabase → Table Editor → visits
- See most popular visiting times
- Track approval rates
- Identify busy periods

### Resident Occupancy
**Where:** Supabase → Table Editor → residents
- Track active residents
- Monitor admissions
- See discharge patterns

### Service Popularity
**Where:** Supabase → Table Editor → services
- Most requested services
- Price analysis
- Availability tracking

---

## 🔍 Specific Data Queries

### "How many users have registered?"
**Supabase → Authentication → Users**
- Count shown at top: "X users"

### "How many family members vs admins?"
**Supabase → SQL Editor:**
```sql
SELECT 
  user_metadata->>'role' as role,
  COUNT(*) as total
FROM auth.users
GROUP BY user_metadata->>'role';
```

### "How many pending visits?"
**Supabase → Table Editor → visits**
- Add filter: `status` equals `pending`
- Count shown at top

### "Which residents have the most visits?"
**Supabase → SQL Editor:**
```sql
SELECT 
  resident_name,
  COUNT(*) as visit_count
FROM visits
GROUP BY resident_name
ORDER BY visit_count DESC;
```

---

## 📧 Exporting Data for Reports

### For Excel/Spreadsheets:
1. Go to Supabase → Table Editor
2. Select your table
3. Click "..." menu
4. Choose "Download as CSV"
5. Open in Excel

### For Analytics Tools:
1. Use Supabase API
2. Connect with tools like:
   - Google Data Studio
   - Tableau
   - PowerBI
   - Metabase

---

## 🔐 Security & Privacy

### Who Can See What:

**Admins:**
- ✅ Can see ALL data
- ✅ Can manage everything
- ✅ Full Supabase access

**Customers (Family Members):**
- ✅ Can see only THEIR visits
- ✅ Can view active residents
- ✅ Can view available services
- ❌ Cannot see other families' data
- ❌ Cannot access admin functions

**Supabase Dashboard:**
- ✅ Only YOU (project owner) can access
- ✅ Requires login credentials
- ✅ All data is secure

---

## 📱 Mobile App vs Supabase Dashboard

| Feature | Mobile App | Supabase Dashboard |
|---------|------------|-------------------|
| View Summary Stats | ✅ Analytics Screen | ✅ SQL Queries |
| Add/Edit Residents | ✅ Admin Screens | ✅ Table Editor |
| Approve Visits | ✅ Admin Screens | ✅ Table Editor |
| View All Users | ❌ Not Available | ✅ Authentication |
| Export Data | ❌ Not Available | ✅ CSV Export |
| Real-time Monitor | ❌ Manual Refresh | ✅ Realtime |
| Custom Queries | ❌ Not Available | ✅ SQL Editor |

**Recommendation:** Use both!
- Mobile app for daily operations
- Supabase Dashboard for reports and analytics

---

## 🎯 Quick Reference

### To View Users:
```
supabase.com → Login → Your Project → Authentication → Users
```

### To View Residents:
```
supabase.com → Login → Your Project → Table Editor → residents
```

### To View Visits:
```
supabase.com → Login → Your Project → Table Editor → visits
```

### To View In-App:
```
App → Admin Login → Dashboard → Analytics Tile
```

---

## 💡 Pro Tips

1. **Bookmark Supabase Dashboard**
   - Quick access to your data
   - https://supabase.com/dashboard/project/YOUR_PROJECT_ID

2. **Set Up Email Notifications**
   - Get notified when new users register
   - Alert for new visit requests

3. **Regular Backups**
   - Supabase auto-backs up daily
   - You can manually export CSV weekly

4. **Monitor Usage**
   - Check Supabase → Project Settings → Usage
   - Track API calls and storage

5. **Create Reports**
   - Use SQL Editor for monthly reports
   - Export data for presentations

---

## 🆘 Troubleshooting

**Can't see any data?**
- Make sure you've added sample data
- Check if tables exist in Table Editor
- Verify app is connected (check supabase_service.dart)

**Data not updating?**
- Pull to refresh in app
- Check internet connection
- Verify Supabase project is active

**Can't access Supabase?**
- Verify your login credentials
- Make sure you're using the correct email
- Reset password if needed

---

## 📞 Need More Help?

**Supabase Documentation:**
https://supabase.com/docs

**Video Tutorials:**
https://youtube.com → Search "Supabase dashboard tutorial"

**Support:**
- Supabase Discord community
- GitHub issues

---

**Remember:** Your Supabase dashboard at https://supabase.com is your DATA COMMAND CENTER! Everything from your app is stored and viewable there. 🎉
