#include<stdio.h>
#include<string.h>
  
int main()
{	
  	int n,i,j,k; 
  	int c;
    float x[10];
  	printf("Enter the number of springs ");  								
  	scanf("%d",&n);
  
  	//declaration of variables here
  float f[n],s[n],A[n][n+1][n+2],B[n][n+1][n+2]; 
  
  	//Clear all Arrays memory to zero
  memset(s,0,sizeof(s)); 
  memset(f,0,sizeof(f));  
  memset(A, 0, (n)*(n+1)*(n+2)*(sizeof(int)));
  memset(B,0, (n)*(n+1)*(n+2)*(sizeof(int)));


  	//store datas for stiffness and force
     for(i=0;i<n;i++)
  		{ printf("Enter the stiffness of spring %d\n",(i+1));	 				
          scanf("%f",&s[i]); }
  
  
    for(i=0;i<=n;i++)
          {	printf("Enter the force applied to the spring %d\n",(i)); 
            scanf("%f",&f[i]); }
 
  
  for(i=0;i<=n;i++){
  	printf("\nforce applied in f[%d] = %.2f",i,f[i]);}
  
	//Arrangment of matrices	
for(k=0;k<n;k++)
  
  for(i=0;i<n+1;i++)
  
    if(i==k||i==(k+1))
      
  { for(j=0;j<n+1;j++)
  	{if(i%2==0&&k%2==0) 
    {
   	if(j==k)
    A[k][i][j]=s[j];
    
    if(j==(k+1))
      A[k][i][j]=-s[j-1]; }
   
   if(i%2==1&&k%2==0) { 
    if(j==k)
    A[k][i][j]=-s[j];
    
    if(j==(k+1))
      A[k][i][j]=s[j-1]; }
     
     if(i%2==0&&k%2==1)
     { if(j==k)
       A[k][i][j]=-s[j];
      
      if(j==(k+1))
        A[k][i][j]=s[j-1];}
     
     if(i%2==1&&k%2==1)
     { if(j==k)
       A[k][i][j]=s[j];
      
      if(j==(k+1))
        A[k][i][j]=-s[j-1]; }
  }
  }
  
  for(k=0;k<n;k++)
  for(i=0;i<n+1;i++)
      for(j=0;j<n+2;j++)
      {  B[0][i][j]=B[0][i][j]+A[k][i][j];
      		if(j==(n+1))
            { B[0][i][j]=f[i];}
      }
   
  //Print Global Matrix
  printf("\n\nGobal Matrix is \n");
  
  
    for(i=0;i<n+1;i++)
    {for(j=0;j<=n+1;j++)
     printf("%.2f\t" ,B[0][i][j]);
    printf("\n");}
    
 //Print nth matrix   
for(k=0;k<n;k++){
	printf("\nmy n=%d matrix is\n",(k+1));
  
  for(i=0;i<(n+1);i++)
  
  	{for(j=0;j<(n+1); j++)
		printf("%.2f\t", A[k][i][j]);
 		
     	printf("\n");
  }
  }
  
  //Computation to solve
     for(j=1; j<=n; j++)
    {
        for(i=1; i<=n; i++)
        {
            if(i!=j)
            {
              c=B[0][i][j]/B[0][j][j];
           
              for(k=1;k<=n+1;k++)
              {
                B[0][i][k]=B[0][i][k]-c*B[0][j][k];}
            
            }
        }
    }
  
  //Print Solution
    printf("\nThe solution is:\n");
    for(i=0; i<n+1; i++)
    {
        x[i]=B[0][i][n+1]/B[0][i][i];
        printf("\n x%d=%.3f\n",i,x[i]);
    }
  
  return 0;
}

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        