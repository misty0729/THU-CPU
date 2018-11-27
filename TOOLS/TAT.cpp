#include<bits/stdc++.h>
#define rep(i,l,r) for(int i=l;i<=r;i++)
#define per(i,r,l) for(int i=r;i>=l;i--)
#define for4(i,x) for(int i=head[x],y=e[i].go;i;i=e[i].next,y=e[i].go)
#define maxn (400000+5)
#define mod (1000000007)
#define ll long long
#define inf 1000000000
#define upmo(a,b) (((a)=((a)+(b))%mo)<0?(a)+=mo:(a))
#define mmo(a,b) (((a)=1ll*(a)*(b)%mo)<0?(a)+=mo:(a))
template<typename T,typename S>inline bool upmin(T&a,const S&b){return a>b?a=b,1:0;}
template<typename T,typename S>inline bool upmax(T&a,const S&b){return a<b?a=b,1:0;}
using namespace std;
const int dx[4] = {-1, 0, 1, 0};
const int dy[4] = {0, 1, 0, -1};
const int dxo[8] = {-1, -1, -1, 0, 1, 1, 1, 0};
const int dyo[8] = {-1, 0, 1, 1, 1, 0, -1, -1};
inline bool is_down(char x) { return ('a' <= x && x <= 'z'); }
inline bool is_upper(char x) { return ('A' <= x && x <= 'Z'); }
inline bool is_digit(char x) { return ('0' <= x && x <= '9'); }
inline int read()
{
    int x=0,f=1;char ch=getchar();
    while(ch<'0'||ch>'9'){if(ch=='-')f=-1;ch=getchar();}
    while(ch>='0'&&ch<='9'){x=10*x+ch-'0';ch=getchar();}
    return x*f;
}
inline ll readll()
{
	ll x=0,f=1;char ch=getchar();
    while(ch<'0'||ch>'9'){if(ch=='-')f=-1;ch=getchar();}
    while(ch>='0'&&ch<='9'){x=10*x+ch-'0';ch=getchar();}
    return x*f;
}
long long gcd(long long x,long long y){return y?gcd(y,x%y):x;}
long long power(long long x,long long y)
{
	long long t=1;
	for(;y;y>>=1,x=x*x%mod)
		if(y&1)t=t*x%mod;
	return t;
}
/*
struct edge
{
	int go,next;
}e[2*maxn];
void insert(int x,int y)
{
	e[++tot]=(edge){y,head[x]};head[x]=tot;
	e[++tot]=(edge){x,head[y]};head[y]=tot;
}
*/
bool QAQ = 0;
void print(int x)
{
	for(int i=7;~i;i--)cout<<(x>>i&1);
}
int main(int argc, char* argv[])
{
	if(argc == 1)
	{
		printf("You need to input something.\n");
		printf("	The first param is src filename (from Assembleler).\n");
		printf("	The second is a int 0/1 to show whether it is for vhdl.\n");
		printf("	The third is dst filename(if need).\n");
		return 0; 
	} 
	if(argc > 3)
	{
		freopen(argv[3],"w",stdout);
	}
	if(argc > 2)
	{
		if(argv[2][0] == '1')
		{
			QAQ = 1;
		}
	}
	FILE *fp = fopen(argv[1],"rb");
	int num = 0;
	short y = 0;
	while(!feof(fp))
	{
		short x = getc(fp);
		num++;
		if(num == 2)
		{
			num = 0;
			if(QAQ)cout<<"\"";
			print(x);
			print(y);
			if(QAQ)cout<<"\",";
			cout<<endl;
		}
		y = x;
	}
	return 0;
}



