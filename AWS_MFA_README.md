# AWS MFA 인증 자동화 스크립트 사용 가이드

## 개요
AWS 2FA(MFA) 인증이 설정된 계정에서 Terraform을 사용하기 위한 자동화 스크립트입니다.

## 파일 설명
- `aws-mfa-auth.sh`: MFA 토큰을 입력받아 임시 자격 증명을 받아오는 메인 스크립트
- `aws-mfa-config.sh`: AWS 계정 정보를 저장하는 설정 파일

## 초기 설정

### 1. 설정 파일 수정
`aws-mfa-config.sh` 파일을 열어 본인의 AWS 정보를 입력하세요:

```bash
export AWS_ACCOUNT_ID="123456789012"  # 본인의 AWS 계정 ID
export IAM_USERNAME="your-username"   # 본인의 IAM 사용자 이름
export SESSION_DURATION="43200"      # 세션 지속 시간 (초, 기본 12시간)
```

### 2. AWS CLI 기본 설정 확인
AWS CLI가 설치되어 있고 기본 자격 증명이 설정되어 있어야 합니다:

```bash
aws configure
```

또는 `~/.aws/credentials` 파일에 기본 자격 증명이 있어야 합니다.

## 사용 방법

### 방법 1: 스크립트 실행 후 현재 셸에서 사용 (권장)
```bash
# MFA 토큰을 인자로 전달
source ./aws-mfa-auth.sh 123456

# 또는 토큰을 입력받도록 실행
source ./aws-mfa-auth.sh
```

### 방법 2: 스크립트 실행 후 환경 변수 복사
```bash
# 스크립트 실행
./aws-mfa-auth.sh 123456

# 출력된 export 명령어를 복사하여 다른 터미널에서 실행
```

### 방법 3: 별도 셸 스크립트로 실행
```bash
./aws-mfa-auth.sh 123456
# 출력된 export 명령어를 복사하여 사용
```

## 사용 예시

```bash
# 1. MFA 인증 실행
source ./aws-mfa-auth.sh 123456

# 2. Terraform 명령어 실행
terraform plan
terraform apply
```

## 주의사항

1. **세션 만료 시간**: 기본적으로 12시간 동안 유효합니다. 만료되면 다시 스크립트를 실행해야 합니다.

2. **환경 변수**: `source` 명령어로 실행하면 현재 셸에 환경 변수가 설정됩니다. 새 터미널에서는 다시 실행해야 합니다.

3. **보안**: 설정 파일(`aws-mfa-config.sh`)에는 민감한 정보가 포함될 수 있으므로 `.gitignore`에 추가하는 것을 권장합니다.

## 문제 해결

### "No valid credential sources found" 오류
- AWS CLI 기본 자격 증명이 설정되어 있는지 확인하세요
- `aws configure` 또는 `~/.aws/credentials` 파일을 확인하세요

### "Invalid MFA token" 오류
- MFA 토큰 코드가 올바른지 확인하세요
- MFA 디바이스의 시간이 정확한지 확인하세요

### "Access denied" 오류
- IAM 사용자에게 `sts:GetSessionToken` 권한이 있는지 확인하세요

