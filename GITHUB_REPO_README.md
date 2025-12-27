# GitHub Repository 생성 가이드

GitHub CLI (`gh`)를 사용하여 로컬 프로젝트를 GitHub에 업로드하는 방법을 안내합니다.

## 📋 사전 요구사항

- GitHub CLI (`gh`) 설치
- GitHub 계정
- 로컬 Git 저장소 초기화 완료

## 🔧 GitHub CLI 설치

### macOS

```bash
# Homebrew를 사용하여 설치
brew install gh

# 설치 확인
gh --version
```

### 다른 플랫폼

- Linux: [GitHub CLI 설치 가이드](https://cli.github.com/manual/installation)
- Windows: `winget install GitHub.cli` 또는 [공식 다운로드](https://cli.github.com/)

## 🔐 GitHub 인증

### 1. GitHub CLI 로그인

```bash
gh auth login
```

### 2. 인증 프로세스

1. **인증 방법 선택**
   - GitHub.com
   - GitHub Enterprise Server

2. **프로토콜 선택**
   - HTTPS (권장)
   - SSH

3. **인증 방법 선택**
   - 브라우저에서 로그인 (권장)
   - 토큰으로 로그인

4. **브라우저 인증 (브라우저 로그인 선택 시)**
   - 터미널에 표시된 URL 열기: `https://github.com/login/device`
   - 표시된 인증 코드 입력 (예: `A258-82C2`)
   - GitHub 계정으로 로그인 및 승인

### 3. 인증 상태 확인

```bash
# 인증 상태 확인
gh auth status

# GitHub 사용자명 확인
gh api user --jq .login
```

## 📦 Repository 생성 방법

### 방법 1: 한 번에 생성 및 푸시 (권장)

현재 디렉토리를 그대로 GitHub에 업로드:

```bash
gh repo create REPOSITORY_NAME \
  --public \
  --description "프로젝트 설명" \
  --source=. \
  --remote=origin \
  --push
```

**옵션 설명:**
- `REPOSITORY_NAME`: Repository 이름
- `--public`: Public repository 생성 (Private은 `--private`)
- `--description`: Repository 설명
- `--source=.`: 현재 디렉토리를 source로 지정
- `--remote=origin`: Remote 이름을 origin으로 설정
- `--push`: 생성 후 자동으로 푸시

**예시:**

```bash
gh repo create terraform-study \
  --public \
  --description "Terraform 학습 실습 - AWS VPC 네트워크 인프라 구성" \
  --source=. \
  --remote=origin \
  --push
```

### 방법 2: 단계별 생성

#### 1단계: Repository 생성

```bash
gh repo create REPOSITORY_NAME \
  --public \
  --description "프로젝트 설명"
```

#### 2단계: Remote 추가

```bash
git remote add origin https://github.com/YOUR_USERNAME/REPOSITORY_NAME.git
```

#### 3단계: 코드 푸시

```bash
git branch -M main
git push -u origin main
```

### 방법 3: 이미 Remote가 설정된 경우

Remote가 이미 설정되어 있고, GitHub에만 repository를 생성하는 경우:

```bash
# Repository만 생성 (코드는 나중에 푸시)
gh repo create REPOSITORY_NAME --public --description "프로젝트 설명"

# 기존 remote 제거 후 새로 추가 (선택사항)
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/REPOSITORY_NAME.git
git push -u origin main
```

## 🔍 Repository 옵션

### 공개/비공개 설정

```bash
# Public repository
gh repo create REPO_NAME --public

# Private repository
gh repo create REPO_NAME --private

# 기본값 (Public)
gh repo create REPO_NAME
```

### Repository 설명 추가

```bash
gh repo create REPO_NAME \
  --description "프로젝트에 대한 간단한 설명"
```

### README 파일 자동 생성

```bash
gh repo create REPO_NAME --add-readme
```

## ✅ 생성 확인

### 1. Remote 확인

```bash
git remote -v
```

출력 예시:
```
origin  https://github.com/USERNAME/REPOSITORY_NAME.git (fetch)
origin  https://github.com/USERNAME/REPOSITORY_NAME.git (push)
```

### 2. 브라우저에서 확인

```bash
# Repository 페이지 열기
gh repo view --web
```

또는 브라우저에서 직접 접속:
```
https://github.com/YOUR_USERNAME/REPOSITORY_NAME
```

### 3. Repository 정보 확인

```bash
# Repository 정보 확인
gh repo view

# Repository URL 확인
gh repo view --json url -q .url
```

## 🔄 이후 작업 흐름

Repository 생성 후 일반적인 Git 작업 흐름:

```bash
# 1. 파일 수정 후 스테이징
git add .

# 2. 커밋
git commit -m "커밋 메시지"

# 3. GitHub에 푸시
git push

# 4. 상태 확인
git status
```

## 🛠️ 유용한 GitHub CLI 명령어

### Repository 관리

```bash
# Repository 목록 확인
gh repo list

# Repository 삭제 (주의!)
gh repo delete REPOSITORY_NAME

# Repository 복제
gh repo clone USERNAME/REPOSITORY_NAME

# Repository 정보 확인
gh repo view USERNAME/REPOSITORY_NAME
```

### Issue 및 Pull Request

```bash
# Issue 목록 확인
gh issue list

# Issue 생성
gh issue create --title "이슈 제목" --body "이슈 내용"

# Pull Request 생성
gh pr create --title "PR 제목" --body "PR 내용"
```

### 인증 관리

```bash
# 인증 상태 확인
gh auth status

# 로그아웃
gh auth logout

# 인증 토큰 새로고침
gh auth refresh
```

## ⚠️ 주의사항

1. **민감한 정보**: `.gitignore`에 민감한 정보가 포함된 파일을 추가했는지 확인하세요.
   - 예: `aws-mfa-config.sh`, `.env`, `terraform.tfstate` 등

2. **Large Files**: 큰 파일은 Git LFS를 사용하거나 제외하세요.

3. **License**: 필요시 LICENSE 파일을 추가하세요.

4. **Repository 이름**: Repository 이름은 나중에 변경할 수 있지만, URL은 변경되지 않습니다.

## 📚 참고 자료

- [GitHub CLI 공식 문서](https://cli.github.com/manual/)
- [GitHub CLI 설치 가이드](https://cli.github.com/manual/installation)
- [Git 기본 명령어](https://git-scm.com/docs)

## 💡 팁

### Repository 이름 규칙

- 소문자, 숫자, 하이픈(`-`)만 사용
- 공백 대신 하이픈 사용: `terraform-study` (O), `terraform study` (X)
- 의미 있는 이름 사용: `my-project`, `terraform-step-01` 등

### Private vs Public

- **Public**: 오픈 소스 프로젝트, 포트폴리오 공유
- **Private**: 개인 프로젝트, 학습용, 민감한 정보 포함

### .gitignore 확인

Repository에 업로드하기 전에 `.gitignore` 파일을 확인하여 불필요한 파일이 커밋되지 않도록 주의하세요.

