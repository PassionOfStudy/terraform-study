#!/bin/bash

# AWS MFA 인증 스크립트
# 사용법: ./aws-mfa-auth.sh <MFA_TOKEN_CODE>
# 또는: source ./aws-mfa-auth.sh <MFA_TOKEN_CODE> (현재 셸에 환경 변수 설정)

# 스크립트 디렉토리 찾기
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 설정 파일이 있으면 자동으로 로드
if [ -f "$SCRIPT_DIR/aws-mfa-config.sh" ]; then
    source "$SCRIPT_DIR/aws-mfa-config.sh"
fi

# 설정 변수 (환경 변수 또는 설정 파일에서 가져옴)
AWS_ACCOUNT_ID="060067310822"  # 예: 123456789012
IAM_USERNAME="mydata-chlim"      # 예: your-username
MFA_DEVICE_ARN="arn:aws:iam::060067310822:mfa/mfa_for_chlim"  # 예: arn:aws:iam::123456789012:mfa/your-username
SESSION_DURATION="43200"  # 12시간 (초 단위)

# 색상 출력
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 설정 확인
if [ -z "$AWS_ACCOUNT_ID" ] || [ -z "$IAM_USERNAME" ]; then
    echo -e "${YELLOW}환경 변수가 설정되지 않았습니다.${NC}"
    echo ""
    echo "다음 중 하나의 방법으로 설정하세요:"
    echo "1. 환경 변수로 설정:"
    echo "   export AWS_ACCOUNT_ID='123456789012'"
    echo "   export IAM_USERNAME='your-username'"
    echo ""
    echo "2. 스크립트 내 변수를 직접 수정"
    echo ""
    read -p "AWS Account ID를 입력하세요: " AWS_ACCOUNT_ID
    read -p "IAM Username을 입력하세요: " IAM_USERNAME
fi

# MFA Device ARN이 없으면 자동 생성
if [ -z "$MFA_DEVICE_ARN" ]; then
    MFA_DEVICE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:mfa/${IAM_USERNAME}"
fi

# MFA 토큰 입력
if [ -z "$1" ]; then
    read -p "MFA 토큰 코드를 입력하세요: " TOKEN_CODE
else
    TOKEN_CODE="$1"
fi

echo -e "${YELLOW}AWS 임시 자격 증명을 요청하는 중...${NC}"

# AWS STS를 사용하여 임시 자격 증명 받기
RESPONSE=$(aws sts get-session-token \
    --serial-number "$MFA_DEVICE_ARN" \
    --token-code "$TOKEN_CODE" \
    --duration-seconds "$SESSION_DURATION" \
    2>&1)

if [ $? -ne 0 ]; then
    echo -e "${RED}오류: 임시 자격 증명을 받을 수 없습니다.${NC}"
    echo "$RESPONSE"
    exit 1
fi

# JSON 파싱하여 환경 변수 추출 (jq가 있으면 사용, 없으면 grep 사용)
if command -v jq &> /dev/null; then
    export AWS_ACCESS_KEY_ID=$(echo "$RESPONSE" | jq -r '.Credentials.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo "$RESPONSE" | jq -r '.Credentials.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo "$RESPONSE" | jq -r '.Credentials.SessionToken')
    EXPIRATION=$(echo "$RESPONSE" | jq -r '.Credentials.Expiration')
else
    export AWS_ACCESS_KEY_ID=$(echo "$RESPONSE" | grep -o '"AccessKeyId": "[^"]*' | cut -d'"' -f4)
    export AWS_SECRET_ACCESS_KEY=$(echo "$RESPONSE" | grep -o '"SecretAccessKey": "[^"]*' | cut -d'"' -f4)
    export AWS_SESSION_TOKEN=$(echo "$RESPONSE" | grep -o '"SessionToken": "[^"]*' | cut -d'"' -f4)
    EXPIRATION=$(echo "$RESPONSE" | grep -o '"Expiration": "[^"]*' | cut -d'"' -f4)
fi

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_SESSION_TOKEN" ]; then
    echo -e "${RED}오류: 자격 증명을 추출할 수 없습니다.${NC}"
    echo "응답: $RESPONSE"
    exit 1
fi

echo -e "${GREEN}✓ AWS 자격 증명이 성공적으로 설정되었습니다!${NC}"
echo ""
echo "설정된 환경 변수:"
echo "  AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID:0:10}..."
echo "  AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY:0:10}..."
echo "  AWS_SESSION_TOKEN: ${AWS_SESSION_TOKEN:0:20}..."
echo ""
echo -e "${YELLOW}만료 시간: $EXPIRATION${NC}"
echo ""
echo -e "${GREEN}현재 셸에서 terraform 명령어를 사용할 수 있습니다.${NC}"
echo -e "${YELLOW}다른 터미널에서 사용하려면 다음 명령어를 실행하세요:${NC}"
echo ""
echo "export AWS_ACCESS_KEY_ID='$AWS_ACCESS_KEY_ID'"
echo "export AWS_SECRET_ACCESS_KEY='$AWS_SECRET_ACCESS_KEY'"
echo "export AWS_SESSION_TOKEN='$AWS_SESSION_TOKEN'"

