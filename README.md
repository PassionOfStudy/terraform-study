# Terraform 학습 실습 - Step 01

AWS VPC 네트워크 인프라를 Terraform으로 구성하는 실습 프로젝트입니다.

## 📋 프로젝트 개요

이 프로젝트는 Terraform을 사용하여 AWS에 기본적인 네트워크 인프라를 구성하는 실습입니다. 다음과 같은 리소스들을 생성합니다:

- VPC (Virtual Private Cloud)
- Internet Gateway
- Public/Private Subnets (멀티 AZ)
- Route Tables 및 Route Table Associations
- Security Groups
- EC2 Instance

## 🛠️ 사전 요구사항

- macOS
- Homebrew
- Terraform (v1.14.3 이상)
- AWS CLI (v2.32.23 이상)
- AWS 계정 및 자격 증명
- MFA (Multi-Factor Authentication) 설정된 AWS 계정

## 📦 설치 방법

### 1. Terraform 설치

```bash
# Homebrew를 사용하여 HashiCorp tap 추가
brew tap hashicorp/tap

# Terraform 설치
brew install hashicorp/tap/terraform

# 설치 확인
terraform --version
```

### 2. AWS CLI 설치

```bash
# AWS CLI 설치
brew install awscli

# 설치 확인
aws --version
```

### 3. AWS 자격 증명 설정

```bash
# AWS 자격 증명 설정 (영구 Access Key 필요)
aws configure
```

설정 항목:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `us-west-2` (또는 원하는 리전)
- Default output format: `json`

## 📁 프로젝트 구조

```
.
├── README.md                  # 프로젝트 메인 문서
├── AWS_MFA_README.md         # AWS MFA 인증 가이드
├── .gitignore                # Git 제외 파일 목록
├── main.tf                   # Terraform 메인 설정 파일
├── aws-mfa-auth.sh          # MFA 인증 자동화 스크립트
└── aws-mfa-config.sh        # MFA 설정 파일 (민감 정보 포함, .gitignore)
```

## 🔐 AWS MFA 인증

본 프로젝트는 MFA가 설정된 AWS 계정을 사용합니다. MFA 토큰을 사용하여 임시 자격 증명을 받아 Terraform을 실행합니다.

### MFA 인증 사용 방법

1. **설정 파일 구성** (최초 1회)

   `aws-mfa-config.sh` 파일을 열어 본인의 AWS 정보를 입력하세요:
   ```bash
   export AWS_ACCOUNT_ID="본인의_계정_ID"
   export IAM_USERNAME="본인의_IAM_사용자명"
   ```

2. **MFA 인증 실행**

   ```bash
   # MFA 토큰 코드를 인자로 전달
   source ./aws-mfa-auth.sh <MFA_TOKEN_CODE>
   
   # 또는 토큰을 입력받도록 실행
   source ./aws-mfa-auth.sh
   ```

3. **인증 확인**

   인증이 성공하면 임시 자격 증명이 환경 변수로 설정됩니다. 만료 시간은 기본 12시간입니다.

자세한 내용은 [AWS_MFA_README.md](./AWS_MFA_README.md)를 참고하세요.

## 🚀 사용 방법

### 1. Terraform 초기화

```bash
terraform init
```

이 명령어는 Terraform provider를 다운로드하고 초기화합니다.

### 2. 실행 계획 확인

```bash
terraform plan
```

생성될 리소스들을 미리 확인할 수 있습니다.

### 3. 인프라 생성

```bash
terraform apply
```

실제로 AWS에 리소스를 생성합니다. 확인 메시지에 `yes`를 입력하거나, 자동 승인하려면:

```bash
terraform apply -auto-approve
```

### 4. 상태 확인

```bash
# 현재 상태 확인
terraform show

# 상태 목록 확인
terraform state list

# 특정 리소스 확인
terraform state show aws_vpc.main
```

### 5. 인프라 삭제

```bash
terraform destroy
```

생성된 모든 리소스를 삭제합니다. 자동 승인:

```bash
terraform destroy -auto-approve
```

## 🏗️ 구성된 리소스

### VPC

- **CIDR**: `10.0.0.0/16`
- **DNS 지원**: 활성화
- **DNS 호스트네임**: 활성화
- **리전**: `us-west-2` (오레곤)

### Internet Gateway

- VPC에 연결된 Internet Gateway
- Public Subnets에서 인터넷 접근을 위한 게이트웨이

### Subnets

#### Public Subnets
- **Public Subnet 1**: `10.0.1.0/24` (us-west-2a)
- **Public Subnet 2**: `10.0.2.0/24` (us-west-2c)

#### Private Subnets
- **Private Subnet 1**: `10.0.10.0/24` (us-west-2a)
- **Private Subnet 2**: `10.0.20.0/24` (us-west-2c)

### Route Tables

- **Public Route Table**
  - Default route: `0.0.0.0/0` → Internet Gateway
  - Public Subnet 1, 2에 연결

### Security Groups

- **Web Security Group**
  - Inbound:
    - HTTP (80) - 0.0.0.0/0
    - HTTPS (443) - 0.0.0.0/0
    - SSH (22) - 0.0.0.0/0
  - Outbound:
    - All traffic - 0.0.0.0/0

### EC2 Instance

- **Instance Type**: t2.micro
- **AMI**: Amazon Linux 2 (us-west-2)
- **Subnet**: Public Subnet 1
- **Security Group**: Web Security Group

## 📝 주요 명령어 요약

```bash
# Terraform 초기화
terraform init

# 실행 계획 확인
terraform plan

# 인프라 생성
terraform apply
terraform apply -auto-approve

# 상태 확인
terraform show
terraform state list

# 인프라 삭제
terraform destroy
terraform destroy -auto-approve

# 형식 검증
terraform fmt
terraform validate
```

## ⚠️ 주의사항

1. **MFA 인증**: MFA 토큰은 약 12시간 후 만료됩니다. 만료되면 다시 인증이 필요합니다.
2. **비용**: 실제 AWS 리소스를 생성하므로 비용이 발생할 수 있습니다. 사용 후 `terraform destroy`로 정리하세요.
3. **민감 정보**: `aws-mfa-config.sh` 파일은 `.gitignore`에 포함되어 있어 Git에 커밋되지 않습니다.
4. **State 파일**: `terraform.tfstate` 파일은 로컬에 저장되며, 실제 환경에서는 Remote State(예: S3) 사용을 권장합니다.

## 📚 참고 자료

- [Terraform 공식 문서](https://www.terraform.io/docs)
- [AWS Provider 문서](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS MFA 인증 가이드](./AWS_MFA_README.md)

## 📄 라이선스

이 프로젝트는 학습 목적으로 작성되었습니다.

## 🔄 변경 이력

### Step 01 - 초기 구성 (2025-12-26)
- Terraform 기본 설정
- AWS MFA 인증 스크립트 구성
- VPC 네트워크 인프라 구성
  - VPC, Internet Gateway
  - Public/Private Subnets (멀티 AZ)
  - Route Tables
  - Security Groups
  - EC2 Instance

