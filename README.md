# 우리집 가계부

GitHub Pages(화면)와 Supabase(DB·로그인)로 서버 없이 쓰는 부부 공용 가계부예요.
한 달 기준은 **매달 10일 시작**이에요. 예를 들어 10월 10일~11월 9일이 "10월" 가계부예요. 설정 탭에서 바꿀 수 있어요.

## 처음 한 번만 설정 (약 15분)

### 1. Supabase
1. https://supabase.com 가입 → **New project** (Region: Northeast Asia (Seoul))
2. **SQL Editor** → `schema.sql` 내용 붙여넣기 → 맨 아래 이메일 두 개를 실제 로그인할 이메일로 수정 → **Run**
3. **Authentication → Users → Add user → Create new user** 로 두 사람 계정 생성 (이메일·비밀번호, *Auto Confirm User* 체크)
4. **Authentication → Sign In / Providers** 에서 **Allow new users to sign up** 끄기
5. **Project Settings → API Keys** 에서 `Project URL` 과 `publishable`(anon) 키 복사

### 2. config.js
복사한 두 값을 `config.js` 에 붙여넣기. (`service_role`/secret 키는 절대 넣지 마세요)

### 3. GitHub Pages
1. GitHub 새 저장소(예: `gagyebu`) → 이 폴더 파일 전부 업로드
2. 저장소 **Settings → Pages** → Source: *Deploy from a branch*, Branch: `main` / `(root)` → Save
3. 1~2분 뒤 `https://<아이디>.github.io/gagyebu/` 접속 → 로그인

### 4. 처음 로그인 후
**설정** 탭에서 구성원 이름(기본: 남편/아내), 결제수단(카드 이름), 카테고리, 월 시작일을 우리 집에 맞게 바꾸세요.

## 계정 추가하기
1. Authentication → Users → Add user (Auto Confirm 체크)
2. SQL Editor: `insert into public.allowed_users (email) values ('추가할이메일') on conflict do nothing;`

## 알아둘 점
- 저장소가 공개여도 괜찮아요. 데이터는 `allowed_users` 에 등록된 이메일로 로그인해야만 읽고 쓸 수 있어요.
- Supabase 무료 플랜은 7일 동안 접속이 없으면 일시정지돼요. 대시보드에서 Restore 누르면 데이터 그대로 돌아와요.
- 백업: 설정 탭 → **전체 백업 (JSON)** 을 가끔 받아두세요.
- 공휴일(휴일이면 당겨 받기 기능)은 2026~2027년만 들어 있어요.
